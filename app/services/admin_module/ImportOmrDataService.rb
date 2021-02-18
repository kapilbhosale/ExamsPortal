# frozen_string_literal: true

module AdminModule
  class ImportOmrDataService
    def call
      process_test_master
      return {status: true, message: 'Attendance Logs imported successfully'}
    rescue ImportAttLogsVError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def process_test_master
      @test_master_data = {}
      file_path = "#{get_base_file_path}/Test_Master.csv"
      csv_file = File.open(file_path, "r:ISO-8859-1")
      CSV.foreach(csv_file, :headers => true).each do |csv_row|
        binding.pry
      end
    end

    def get_base_file_path
      "#{Rails.root}/zip_data"
    end
  end
end

