class UploadExamError < StandardError; end

module Exams
  class Upload
    attr_reader :exam, :section_id, :marks
    attr_accessor :tmp_zip_file

    S3_UPLOAD = false

    def initialize(exam, tmp_zip_file, section_id = 1, marks = {})
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
        convert_images_to_grayscale
        upload_images_folder
        parse_html
        create_questions_and_options
        remove_zip_files
      end
      { status: true }
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

    def convert_images_to_grayscale
      images_folder = "#{@tmp_dir_path}images"
      Dir.glob("#{images_folder}/*.png") do |img_filename|
        img = (Magick::Image.read(img_filename).first rescue nil)
        next if img.nil?

        img.quantize(256, Magick::GRAYColorspace)
        img.write img_filename
      end
    end

    def upload_images_folder
      images_folder = "#{@tmp_dir_path}images"
      if S3_UPLOAD
        uploader = Exams::S3FolderUpload.new(images_folder, "#{@path}/images")
        uploader.upload!
      else
        local_path = "public/uploads/#{@path}/images"
        FileUtils.mkdir_p(File.dirname(local_path))
        FileUtils.mv images_folder, local_path
      end
    rescue Exception, StandardError => e
      puts "Error uploading ..."
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
        options_val = []
        # copy options table and remove it.
        options_table = table.at('table')
        table.at('table').remove

        options_table.search('tr').each do |option|
          img_base64 = nil
          img_name = option.at('td').children.at('img')&.attributes&.dig('src')&.value
          if img_name
            img_base64 = Base64.encode64(open("#{Rails.root}/public/uploads/#{@path}/#{img_name}") { |io| io.read })
          end

          options << {
            data: (img_base64 || option.at('td').children.to_s.strip),
            is_image: img_base64.present?
          }
          options_val << option.at('td').children.text.strip
        end

        rows = table.search('tr')
        # assuming that there will be only 4 rows in question, as per defined structure.

        question_val = rows[0].at('td').text.strip
        question_type = question_val.downcase.strip.start_with?('[input]') ? 2 : 0
        question = rows[0].at('td').children.to_s.strip
        img_base64 = nil
        img_name = rows[0].at('td').children.at('img')&.attributes&.dig('src')&.value
        if img_name
          img_base64 = Base64.encode64(open("#{Rails.root}/public/uploads/#{@path}/#{img_name}") { |io| io.read })
        end
        answer = rows[2].text.strip
        explanation = rows[3]&.at('td')&.children&.to_s&.strip

        @questions_data << {
          question: (img_base64 || question),
          q_is_image: img_base64.present?,
          question_type: question_type,
          options: options,
          optinos_val: options_val,
          answer: answer,
          explanation: explanation
        }
      end
    end

    def question_type_from_sections
      {
        "phy-I" => Question.question_types[:multi_select], 
        "phy-II" => Question.question_types[:input], 
        "phy-III" => Question.question_types[:single_select], 
        "chem-I"=> Question.question_types[:multi_select],
        "chem-II" => Question.question_types[:input], 
        "chem-III" =>  Question.question_types[:single_select], 
        "math-I"=> Question.question_types[:multi_select],
        "math-II" => Question.question_types[:input], 
        "math-III" => Question.question_types[:single_select]
      }
    end

    def create_questions_and_options
      @questions_data.each do |question_data|

        # title = replace_local_img_path(question_data[:question])
        # explanation = replace_local_img_path(question_data[:explanation])
        title = question_data[:question]
        explanation = question_data[:explanation]
        question = Question.create!(
          title: title,
          is_image: question_data[:q_is_image],
          explanation: explanation,
          section_id: section_id,
          question_type: question_data[:question_type]
        )
        ExamQuestion.create(exam: exam, question: question)

        create_option_params = []
        if question_data[:question_type] == 0
          question_data[:options].each_with_index do |option, index|
            create_option_params << {
              question: question,
              # data: replace_local_img_path(option),
              data: option[:data],
              is_image: option[:is_image],
              is_answer: answer_input(question_data[:answer]) == index + 1
            }
          end
        else
          create_option_params << {
            question: question,
            data: question_data[:answer],
            is_answer: true
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
      return if html_code.blank?
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

