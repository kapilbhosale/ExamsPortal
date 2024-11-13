# file_path = '/Users/kapilbhosale/Downloads/test_zip/Batch_Test_Detail.csv'
# Omr::ImportBatchTests.new(1, 'latur', file_path).call

class Omr::ImportBatchTests
  attr_reader :org_id, :branch, :file_path

  def initialize(org_id, branch, file_path)
    @org_id = org_id
    @branch = branch
    @file_path = file_path
  end

  def call
    csv_file = File.open(file_path, "r:ISO-8859-1")

    new_batch_tests = []
    batch_size = 1000
    test_id_mapping = Omr::Test.where(org_id: org_id, branch: branch).pluck(:old_id, :id).to_h
    batch_id_mapping = Omr::Batch.where(org_id: org_id, branch: branch).pluck(:old_id, :id).to_h

    begin
      CSV.foreach(csv_file, headers: true).each do |csv_row|
        old_test_id = csv_row['Test_ID'].to_i
        old_batch_id = csv_row['Batch_ID'].to_i


        new_test_id = test_id_mapping[old_test_id]
        new_batch_id = batch_id_mapping[old_batch_id]

        if new_test_id.nil? || new_batch_id.nil?
          puts "Mapping not found for Test_ID: #{new_test_id} or Batch_ID: #{old_batch_id}"
          next
        end

        new_batch_tests << {
          omr_test_id: new_test_id,
          omr_batch_id: new_batch_id
        }

        if new_batch_tests.size >= batch_size
          insert_data(new_batch_tests)
          new_batch_tests.clear
        end
      end

      # Insert any remaining entries
      insert_data(new_batch_tests) unless new_batch_tests.empty?
    rescue CSV::MalformedCSVError => e
      puts "CSV parsing error: #{e.message}"
    ensure
      csv_file.close
    end
  end

  private

  def insert_data(data)
    puts "Inserting #{data.size} batch tests"
    Omr::BatchTest.import(
      data,
      on_duplicate_key_ignore: true
    )
  rescue ActiveRecord::ActiveRecordError => e
    puts "Database insertion error: #{e.message}"
  end
end


# def process_batch_tests
#   file_path = "#{get_base_file_path}/Batch_Test_Detail.csv"
#   csv_file = File.open(file_path, "r:ISO-8859-1")
#   CSV.foreach(csv_file, :headers => true).each do |csv_row|
#     # next if csv_row['Is_Delete'] == 'True'
#     Omr::BatchTest.find_or_create_by(
#       omr_batch_id: csv_row['Batch_ID'].to_i,
#       omr_test_id: csv_row['Test_ID'].to_i
#     )
#   end
# end