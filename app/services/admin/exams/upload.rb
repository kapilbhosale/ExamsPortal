class UploadExamError < StandardError; end

module Admin
  module Exams
    class Upload
      attr_accessor :tmp_zip_file

      def initialize(tmp_zip_file)
        @tmp_zip_file = tmp_zip_file
      end

      def call
        validate_request
        ActiveRecord::Base.transaction do
          extract_zip
          upload_images_folder
          parse_response = parse_html
          remove_zip_files
        end
        return {status: true, data: parse_response}
      rescue UploadExamError, ActiveRecord::RecordInvalid => ex
        return {status: false, message: ex.message}
      end

      private

      def extract_zip
        zip_name = "zip_#{Time.now.to_i}"
        zip_file_path = "#{Rails.root}/tmp/#{zip_name}.zip"
        @tmp_dir_path = "#{Rails.root}/tmp/zip_data/#{@exam.id}/"
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
        uploader = Utils::S3FolderUpload.new(images_folder, "exam#{@exam.id}/images")
        uploader.upload!
      end


      def parse_html
        html_files = Dir["#{@tmp_dir_path}/*.html"]
        return if html_files.blank?

        file = File.open(html_files.first)
        doc = Nokogiri::HTML(file)

        style = doc.at('style').text

        tables = doc.search('table')
        questions_data = []

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
          question = rows[0].at('td').children.to_s.strip
          answer = rows[2].text.strip
          explanation = rows[3].at('td').children.to_s.strip

          questions_data << {
            question: question,
            options: options,
            answer: answer,
            explanation: explanation
          }
        end
        {style: style, questions_data: questions_data}
      end

      def options_table?(table)
        !table.search('table').present?
      end

      def validate_request
        raise UploadExamError, 'No file present to process' if tmp_zip_file.blank?
      end

    end
  end
end
