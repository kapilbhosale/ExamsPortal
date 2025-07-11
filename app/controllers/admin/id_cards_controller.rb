class Admin::IdCardsController < Admin::BaseController
  def index
    @photo_upload_logs = PhotoUploadLog.order(created_at: :desc)
  end

  def upload_photos
    temp_file = params["photos_zip"].tempfile rescue nil

    if temp_file
      extract_zip(temp_file.path)
      associate_photos_to_students(temp_file.path)
      cleanup_photos
      flash[:success] = "Photos uploaded successfully"
    else
      flash[:error] = "Please upload a zip file"
    end

    redirect_to admin_id_cards_path
  end

  def print_cards
    @batches = Batch.where(org_id: current_org.id).where(id: current_admin.batches.ids).order(:name)
    @from_date = Date.parse(params[:from_date]) rescue Date.today.strftime("%Y-%m-%d")
    @to_date = Date.parse(params[:to_date]) rescue Date.today.strftime("%Y-%m-%d")

    if params[:batch_id].present?
      @selected_batch = Batch.find_by(id: params[:batch_id])
      @fees_transactions = FeesTransaction.current_year
        .where(org_id: current_org.id)
        .where(batch_id: @selected_batch.id)
        .where('fees_transactions.created_at >= ?', Date.parse(params[:from_date]).beginning_of_day)
        .where('fees_transactions.created_at <= ?', Date.parse(params[:to_date]).end_of_day)
        .where(remaining_amount: 0)
    else
      @fees_transactions = []
    end
  end


  def generate_prints
    batch = Batch.find(params[:selected_batch_id])
    # batch_display_name = batch.name.match(/\[(.*?)\]/)[1]
    batch_display_name = batch.name
    pdf = Prawn::Document.new(page_size: [inches_to_points(12), inches_to_points(18)], page_layout: :landscape)

    if params[:all].present?
      selected_students = Student.where(id: JSON.parse(params[:all_student_ids]))
    else
      selected_students = Student.where(id: params[:student_ids])
    end

    if params[:commit] == "pdf"
      selected_students.each_slice(18) do |students|
        x, y = 0, 12
        pdf.canvas do
          students.each do |student|
            ids_data = student.id_card || []

            ids_data << "#{Time.current.strftime("%d-%B-%Y %I:%M%p")} by #{current_admin.email.split('@')[0]}"
            student.update(id_card: ids_data)

            add_id_card(pdf, student, batch_display_name, inches_to_points(x), inches_to_points(y))
            x >= 15 ? (x = 0; y -= 4) : x += 3
          end
        end
        pdf.start_new_page
      end
      send_data pdf.render, filename: "id-cards-#{batch_display_name}.pdf", type: "application/pdf"
    else
      id_cards_csv = CSV.generate(headers: true) do |csv|
        header_row = ['ID', 'Roll No', 'Name', 'Parent Mobile', 'Student Mobile', 'Batch Name']
        csv << header_row
        selected_students.each do |student|
          ids_data = student.id_card || []
          ids_data << "#{Time.current.strftime("%d-%B-%Y %I:%M%p")} by #{current_admin.email.split('@')[0]}"
          student.update(id_card: ids_data)

          csv << [student.id, student.roll_number, student.name, student.parent_mobile, student.student_mobile, batch_display_name]
        end
      end

      send_data id_cards_csv, filename: "id-cards-#{Date.today}-#{batch_display_name}.csv"
    end
  end

  private

  def add_id_card(pdf, student, batch_display_name, x, y)
    qr_code = RQRCode::QRCode.new("#{student.id}|#{student.roll_number}")
    profile_photo = open(student.photo.profile.url) rescue false

    pdf.fill_color '000000'
    pdf.image("app/assets/images/id-bg-12.jpg", scale: 0.2417, at: [x, y])

    if profile_photo != false
      pdf.image(profile_photo, at: [x + 65, y - 64], width: 83, height: 97)
    end

    pdf.move_cursor_to(y - 90)

    pdf.indent(7 + x) do
      pdf.render_qr_code(qr_code, extent: 50)
    end

    if student.name.length >= 25
      pdf.text_box student.name&.titlecase, at: [x + 5, y - 168], width: inches_to_points(3) - 10, align: :center, size: 16, style: :bold
    else
      pdf.text_box student.name&.titlecase, at: [x + 5, y - 180], width: inches_to_points(3) - 10, align: :center, size: 16, style: :bold
    end

    pdf.fill_color 'FFFFFF'
    pdf.text_box student.roll_number.to_s, at: [x, y - 207], width: inches_to_points(3), align: :center, size: 18, style: :bold
    pdf.fill_color 'FF0000'
    pdf.text_box "Batch: #{batch_display_name.upcase}", at: [x, y - 230], width: inches_to_points(3), align: :center, size: 18, style: :bold
  end

  def inches_to_points(inches)
    inches * 72 # Assuming 1 inch = 72 points
  end

  def extract_zip(temp_file_path)
    Zip::ZipFile.open(temp_file_path) do |zip_file|
      zip_file.each do |f|
        f_path = File.join("#{base_file_path}", f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) {true}
      end
    end
  end

  def base_file_path
    "#{Rails.root}/public/photos_zip_data"
  end

  def associate_photos_to_students(file_name)
    success, not_found = [], []

    Dir.glob("#{base_file_path}/*") do |file|
      roll_number = File.basename(file, ".*")
      if roll_number
        student = Student.find_by(roll_number: roll_number)
        if student
          student.photo = File.open(file)
          student.save
          success << roll_number
          Rails.logger.info "----------------> updated student #{student.id}"
        else
          not_found << roll_number
        end
      end
    end

    PhotoUploadLog.create(
      filename: file_name,
      uploaded_by: current_admin.email,
      success_count: success.count,
      sucess_roll_numbers: success,
      not_found_count: not_found.count,
      not_found_roll_numbers: not_found
    )
  end

  def cleanup_photos
    FileUtils.rm_rf(Dir.glob("#{base_file_path}/*"))
  end
end
