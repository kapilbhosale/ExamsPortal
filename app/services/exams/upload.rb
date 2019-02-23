class UploadExamError < StandardError; end

module Exams
  class Upload
    attr_reader :exam, :section_id, :marks
    attr_accessor :tmp_zip_file

    S3_UPLOAD = false

    def initialize(exam, tmp_zip_file, section_id=1, marks={})
      @exam = exam
      @tmp_zip_file = tmp_zip_file
      @section_id = section_id
      @path = "exam_#{exam.id}_#{section_id}"
      @marks = marks
    end

    def call
      validate_request
      ActiveRecord::Base.transaction do
        create_exam_section
        extract_zip
        upload_images_folder
        parse_html
        create_questions_and_options
        remove_zip_files
      end
      return {status: true}
    rescue UploadExamError, ActiveRecord::RecordInvalid => ex
      raise StandardError ex.message
    end

    private

    def create_exam_section
      section = Section.find_by(id: section_id)
      if section
        exam.exam_sections.create(
          section_id: section.id,
          positive_marks: marks[:positive_marks],
          negative_marks: marks[:negative_marks]
        )
      end
    end

    def extract_zip
      zip_name = "zip_#{Time.now.to_i}"
      zip_file_path = "#{Rails.root}/tmp/#{zip_name}.zip"
      @tmp_dir_path = "#{Rails.root}/tmp/zip_data/#{@path}/"
      FileUtils.mv tmp_zip_file, zip_file_path

      Zip::ZipFile.open(zip_file_path) { |zip_file|
        zip_file.each { |f|
          f_path=File.join(@tmp_dir_path, f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) {true}
        }
      }
    end

    def remove_zip_files
      FileUtils.rm_rf(Dir.glob(@tmp_dir_path))
    end

    def upload_images_folder
      images_folder = "#{@tmp_dir_path}/images"
      if S3_UPLOAD
        uploader = Exams::S3FolderUpload.new(images_folder, "#{@path}/images")
        uploader.upload!
      else
        local_path = "public/uploads/#{@path}/images"
        FileUtils.mkdir_p(File.dirname(local_path))
        FileUtils.mv images_folder, local_path
      end
    end


    def parse_html
      html_files = Dir["#{@tmp_dir_path}/*.html"]
      return if html_files.blank?

      file = File.open(html_files.first)
      doc = Nokogiri::HTML(file)

      @style = doc.at('style').text

      tables = doc.search('table')
      @questions_data = []

      tables.each do |table|
        next if options_table?(table)
        options = []
        # copy options table and remove it.
        options_table = table.at('table')
        table.at('table').remove

        options_table.search('tr').each do |option|
          options << option.at('td').children.to_s.strip
        end

        rows = table.search('tr')
        # assuming that there will be only 4 rows in question, as per defined structure.
        question_val = rows[0].at('td').text.strip
        question = rows[0].at('td').children.to_s.strip
        answer = rows[2].text.strip
        explanation = rows[3].at('td').children.to_s.strip

        @questions_data << {
          question: question,
          options: options,
          answer: answer,
          explanation: explanation
        } if question_val.present?
      end
    end

    def create_questions_and_options
      @questions_data.each do |question_data|

        title = replace_local_img_path(question_data[:question])
        explanation = replace_local_img_path(question_data[:explanation])
        question = Question.create!(title: title, explanation: explanation, section_id: section_id)
        ExamQuestion.create(exam: exam, question: question)

        create_option_params = []
        question_data[:options].each_with_index do |option, index|
          create_option_params << {
            question: question,
            data: replace_local_img_path(option),
            is_answer: answer_input(question_data[:answer]) == index + 1
          }
        end
        Option.create!(create_option_params)
        ComponentStyle.create!(component: question, style: @style)
      end
    end

    def answer_input(input)
      input.downcase!
      return 1 if input == 'a'
      return 2 if input == 'b'
      return 3 if input == 'c'
      return 4 if input == 'd'
      return 5 if input == 'e'
      return 6 if input == 'f'
      input.to_i
    end

    def replace_local_img_path(html_code)
      if S3_UPLOAD
        path_to_replace = "#{Exams::S3FolderUpload.get_base_path}/#{@path}/images/"
      else
        path_to_replace = "/uploads/#{@path}/images/"
      end
      html_code.gsub('images/', path_to_replace)
    end

    def options_table?(table)
      !table.search('table').present?
    end

    def validate_request
      raise UploadExamError, 'No file present to process' if tmp_zip_file.blank?
    end

  end
end

