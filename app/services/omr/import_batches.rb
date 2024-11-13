# file_path = '/Users/kapilbhosale/Downloads/test_zip/Batch_Master.csv'
# Omr::ImportBatches.new(1, 'latur', file_path).call
class Omr::ImportBatches
  attr_reader :org_id, :branch, :file_path

  def initialize(org_id, branch, file_path)
    @org_id = org_id
    @branch = branch
    @file_path = file_path
  end

  def call
    csv_file = File.open(file_path, "r:ISO-8859-1")
    batches_to_insert = []

    begin
      CSV.foreach(csv_file, headers: true).each do |csv_row|
        batches_to_insert << {
          org_id: org_id,
          name: csv_row['Batch_Name'],
          db_modified_date: csv_row['Date_Of_Modification'],
          branch: branch,
          old_id: csv_row['Batch_ID'].to_i
        }
      end
      insert_batches(batches_to_insert)
    ensure
      csv_file.close
    end
  end

  private
  def insert_batches(batches)
    puts "Inserting #{batches.size} batches"
    Omr::Batch.import(
      batches,
      on_duplicate_key_ignore: true
    )
  end
end


# def process_batch_master
#   file_path = "#{get_base_file_path}/Batch_Master.csv"
#   csv_file = File.open(file_path, "r:ISO-8859-1")
#   CSV.foreach(csv_file, :headers => true).each do |csv_row|
#     # next if csv_row['Is_Delete'] == 'True'
#     batch = Omr::Batch.find_by(id: csv_row['Batch_ID'])
#     unless batch.present?
#       Omr::Batch.create(
#         id: csv_row['Batch_ID'].to_i,
#         name: csv_row['Batch_Name'],
#         org_id: 1,
#         db_modified_date: csv_row['Date_Of_Modification'],
#         branch: branch
#       )
#     end
#   end
# end