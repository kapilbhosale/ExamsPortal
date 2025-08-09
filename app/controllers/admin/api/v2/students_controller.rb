class Admin::Api::V2::StudentsController < Admin::Api::V2::ApiController

  def index
    if params[:type] == 'online' && params[:roll_number].present?
      # new_admission = NewAdmission.find_by(id: params[:ref_number])
      # if new_admission.present?
      #   student_id = new_admission.student_id
      #   @students = Student.where(id: student_id)
      # end
      if current_admin.roles.include?('online_pay')
        @students = Student.where(org_id: current_org.id, roll_number: params[:roll_number])
      else
        @students = []
      end
    else
      if params[:qr_code].present?
        student_id = params[:qr_code].split("|")[1]
        @students = Student.where(id: student_id)
      elsif params[:roll_number].present? && params[:parent_mobile].present?
        @students = Student.where(org_id: current_org.id, roll_number: params[:roll_number], parent_mobile: params[:parent_mobile])
      elsif params[:roll_number].present?
        @students = Student.where(org_id: current_org.id, roll_number: params[:roll_number])
      elsif params[:parent_mobile].present?
        @students = Student.where(org_id: current_org.id, parent_mobile: params[:parent_mobile])
      end

      if @students.present?
        batch_ids = Batch.where(org_id: current_org.id).joins(:batch_fees_templates).ids.uniq
        # filtering batches of the current admin only.
        batch_ids = current_admin.batches.ids & batch_ids
        if params[:is_new] == 'true'
          @students = @students.includes(:batches).where(batches: { id: batch_ids })
        else
          @students = @students.joins(:fees_transactions).includes(:batches).where(batches: { id: batch_ids })
        end
      end
    end
  end

  def suggested_roll_number
    roll_number = (params[:orgCode] == '102' ? Student.random_roll_number(5) : Student.random_roll_number)

    render json: { roll_number: roll_number }
  end

  def create
    system_roll_number = params[:roll_number] || Student.random_roll_number
    errors = []

    # errors << "Invalid permissions" unless current_admin.roles.include?('payments')

    errors << "In-valid batch" if params[:batch_id].blank?

    if params[:parentMobile].to_s.length != 10 || params[:studentMobile].to_s.length != 10
      errors << "In-valid student or parent mobile"
    end

    errors << "In-valid batch" if params[:batch_id].blank?
    batch = Batch.find(params[:batch_id])
    errors << "In-valid batch" if batch.blank?

    render json: errors, status: :unprocessable_entity and return if errors.present?

    create_student_params = student_params.merge({
      org_id: current_org.id,
      gender: params[:gender] == 'male' ? 0 : 1,
      email: "#{system_roll_number}@#{current_org.subdomain}.eduaakar.com",
      roll_number: system_roll_number,
      password: student_params[:parent_mobile],
      raw_password: student_params[:parent_mobile],
      data: { discount_id: params[:discountId]}
    })

    student = Student.create(create_student_params)

    if student.errors.present?
      render json: student.errors.full_messages, status: :unprocessable_entity and return
    end

    student.batches << batch
    if current_org.rcc? && params[:rcc_batch].present? && params[:rcc_batch] != '-'
      student.data[:rcc_batch] = params[:rcc_batch]
      student.save

      batch_name = batch.name
      batch_name = "11th-LTR-PCB-2023-24" if batch.id == 857
      second_batch = Batch.find_by(org_id: current_org.id, name: "#{batch_name} [#{params[:rcc_batch]}]")
      student.batches << second_batch if second_batch
    end

    render json: student
  end

  # need to add a filter to show, students associated with the current admin.
  def pending_amount
    if params[:qr_code].present?
      student_id = params[:qr_code].split("|")[1]
      @student = Student.find_by(id: student_id)
    else
      batch_ids = current_admin.batches.ids
      if params[:roll_number].present? & params[:parent_mobile].present?
        @students = Student.where(org_id: current_org.id).includes(:batches).where(batches: { id: batch_ids }).where(roll_number: params[:roll_number], parent_mobile: params[:parent_mobile])
      elsif params[:roll_number].present?
        @students = Student.where(org_id: current_org.id).includes(:batches).where(batches: { id: batch_ids }).where(roll_number: params[:roll_number])
      elsif params[:parent_mobile].present?
        @students = Student.where(org_id: current_org.id).includes(:batches).where(batches: { id: batch_ids }).where(parent_mobile: params[:parent_mobile])
      end
      @student = @students.first
    end

    render json: { message: "student not found" }, status: :unprocessable_entity and return if @student.blank?

    @pending_amount = FeesTransaction.student_pending_fees(@student.id)
    @paid_percent = FeesTransaction.student_paid_percent(@student.id, @pending_amount) rescue 0
    if @pending_amount >= 4_00_000
      @message = "No Template assigned to student batch"
    end
  end

  def issued_notes
    @student_notes = StudentNote.where(student_id: params[:student_id]).includes(:note)
  end

  def issue_notes
    if params[:student_id].present? && params[:note_id].present?
      student_note = StudentNote.create(
        org_id: current_org.id,
        student_id: params[:student_id],
        note_id: params[:note_id],
        comment: params[:comment],
      )

      render json: student_note and return
    end

    render json: {message: "Can not create student notes"}, status: :unprocessable_entity
  end

  def change_course
    # unless current_admin.roles.include?('change_course')
    #   render json: {message: "Can not change course"}, status: :unprocessable_entity
    # end

    student = Student.find_by(org_id: current_org.id, id: params[:student_id])
    batch = Batch.find_by(id: params[:new_batch_id])

    if student && batch
      CourseChangeEntry.create({
        student: student,
        old_batch_id: student.batches.joins(:batch_fees_templates).ids.uniq.first,
        new_batch_id: batch.id,
        pending_amount: FeesTransaction.student_pending_fees(student.id),
        fees_paid_data: student.fees_transactions&.as_json
      })
      student.batches.destroy_all
      student.batches << batch

      # soft deleting fees tranactions with paranoid gem, so that we can refer them.
      student.fees_transactions.destroy_all

      render json: {message: "successful."}
    else
      render json: {message: "Can not change course"}, status: :unprocessable_entity
    end
  end

  def apply_discount
    student = Student.find_by(org_id: current_org.id, id: params[:student_id])

    if student
      student.data[:discount_id] = params[:discount_id]
      student.save
      render json: {} and return
    end

    render json: {message: "Cannot apply discount"}, status: unprocessable_entity
  end

  private

  def student_params
    {
      name: params[:name],
      mother_name: params[:mother_name],
      date_of_birth: params[:date_of_birth],
      ssc_marks: params[:ssc_marks],
      address: params[:address],
      student_mobile: params[:studentMobile],
      parent_mobile: params[:parentMobile],
      category: params[:category]
    }
  end
end
  