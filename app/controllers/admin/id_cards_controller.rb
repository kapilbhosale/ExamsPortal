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
    @batches = Batch.where(org_id: current_org.id).where(id: current_admin.batches.ids).where('name ILIKE ?', '%[%]%').order(:name)
    if params[:batch_id].present?
      @selected_batch = Batch.find_by(id: params[:batch_id])
      fees_transactions = FeesTransaction.includes(student: [:batches, :student_batches])
      @fees_transactions = fees_transactions.current_year
        .where(org_id: current_org.id)
        .where('fees_transactions.created_at >= ?', Date.parse(params[:from_date]).beginning_of_day)
        .where('fees_transactions.created_at <= ?', Date.parse(params[:to_date]).end_of_day)
        .where(students: { student_batches: { batch_id: params[:batch_id] }})
        .where(remaining_amount: 0)
    else
      @fees_transactions = []
    end
  end


  def generate_prints
    batch = Batch.find(params[:selected_batch_id])
    batch_display_name = batch.name.match(/\[(.*?)\]/)[1]
    pdf = Prawn::Document.new(page_size: [inches_to_points(12), inches_to_points(18)], page_layout: :landscape)

    if params[:all].present?
      selected_students = Student.where(id: JSON.parse(params[:all_student_ids]))
    else
      selected_students = Student.where(id: params[:student_ids])
    end

    selected_students.each_slice(18) do |students|
      x, y = 0, 12
      pdf.canvas do
        students.each do |student|
          add_id_card(pdf, student, batch_display_name, inches_to_points(x), inches_to_points(y))
          x >= 15 ? (x = 0; y -= 4) : x += 3
        end
      end
      pdf.start_new_page
    end

    send_data pdf.render, filename: "id-cards-#{batch_display_name}.pdf", type: "application/pdf"
  end

  private

  def add_id_card(pdf, student, batch_display_name, x, y)
    qr_code = RQRCode::QRCode.new("#{student.id}", mode: :number)

    pdf.fill_color '000000'
    pdf.image("app/assets/images/id-bg-12.jpg", scale: 1, at: [x, y])

    if student.photo.url.present?
      pdf.image(open(student.photo.url), at: [x + 63, y - 62], fit: [88, 150])
    end

    pdf.move_cursor_to(y - 90)

    pdf.indent(7 + x) do
      pdf.render_qr_code(qr_code, extent: 50)
    end

    pdf.text_box student.name&.titlecase, at: [x, y - 180], width: inches_to_points(3), align: :center, size: 16
    pdf.fill_color 'FFFFFF'
    pdf.text_box student.roll_number.to_s, at: [x, y - 205], width: inches_to_points(3), align: :center, size: 18, style: :bold
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
