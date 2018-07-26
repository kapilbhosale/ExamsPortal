class Admin::ExamsController < Admin::BaseController

  def index
    @exams = Exam.all.order(id: :desc)
  end

  def new
  end

  def create
    @exam = Exam.new(exam_params)
    if @exam.save
      extract_zip(params[:questions_zip].tempfile) if params[:questions_zip].present?
      redirect_to admin_exams_path
    else
      render 'new'
    end
  end

  private

  def exam_params
    params.permit(:name, :description, :no_of_questions, :time_in_minutes)
  end

  def extract_zip(tmp_zip_file)
    zip_name = "zip_#{Time.now.to_i}"
    zip_file_path = "#{Rails.root}/tmp/#{zip_name}.zip"

    # remove old data zip and csv files
    # FileUtils.rm_rf(Dir.glob("#{Rails.root}/zip_data/*.csv"))
    # FileUtils.rm_rf(Dir.glob("#{Rails.root}/zip_data/*.zip"))

    FileUtils.mv tmp_zip_file, zip_file_path

    Zip::ZipFile.open(zip_file_path) { |zip_file|
      zip_file.each { |f|
        f_path=File.join("#{Rails.root}/tmp/zip_data/", f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) {true}
      }
    }
    binding.pry
  end

end

# Imgur
# client_id : 5b8da04bb57e141
# secret : ad9a52bcab65dbd79b68c2b98b53eec9c1fbecb6
