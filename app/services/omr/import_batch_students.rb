# file_path = '/Users/kapilbhosale/Downloads/test_zip/Batch_Student.csv'
# Omr::ImportBatchStudents.new(1, 'latur', file_path).call

class Omr::ImportBatchStudents
  attr_reader :org_id, :branch, :file_path

  def initialize(org_id, branch, file_path)
    @org_id = org_id
    @branch = branch
    @file_path = file_path
  end

  def call
    csv_file = File.open(file_path, "r:ISO-8859-1")

    new_student_batches = []
    batch_size = 1000
    student_id_mapping = Omr::Student.where(org_id: org_id, branch: branch).pluck(:old_id, :id).to_h
    batch_id_mapping = Omr::Batch.where(org_id: org_id, branch: branch).pluck(:old_id, :id).to_h

    begin
      CSV.foreach(csv_file, headers: true).each do |csv_row|
        old_student_id = csv_row['Student_ID'].to_i
        old_batch_id = csv_row['Batch_ID'].to_i

        new_student_id = student_id_mapping[old_student_id]
        new_batch_id = batch_id_mapping[old_batch_id]

        if new_student_id.nil? || new_batch_id.nil?
          puts "Mapping not found for Student_ID: #{old_student_id} or Batch_ID: #{old_batch_id}"
          next
        end

        new_student_batches << {
          omr_student_id: new_student_id,
          omr_batch_id: new_batch_id
        }

        if new_student_batches.size >= batch_size
          insert_data(new_student_batches)
          new_student_batches.clear
        end
      end

      # Insert any remaining entries
      insert_data(new_student_batches) unless new_student_batches.empty?
    rescue CSV::MalformedCSVError => e
      puts "CSV parsing error: #{e.message}"
    ensure
      csv_file.close
    end
  end

  private

  def insert_data(data)
    puts "Inserting #{data.size} student batches"
    Omr::StudentBatch.import(
      data,
      on_duplicate_key_ignore: true
    )
  rescue ActiveRecord::ActiveRecordError => e
    puts "Database insertion error: #{e.message}"
  end
end


# def process_batch_students
#   file_path = "#{get_base_file_path}/Batch_Student.csv"
#   csv_file = File.open(file_path, "r:ISO-8859-1")
#   existing_student_batches = Omr::StudentBatch.pluck(:omr_student_id, :omr_batch_id)
#   new_student_batches = []
#   CSV.foreach(csv_file, :headers => true).each do |csv_row|
#     # next if csv_row['Is_Delete'] == 'True'
#     student_batch_key = [csv_row['Student_ID'].to_i, csv_row['Batch_ID'].to_i]
#     next if existing_student_batches.include?(student_batch_key)

#     new_student_batches << Omr::StudentBatch.new(
#       omr_student_id: student_batch_key[0],
#       omr_batch_id: student_batch_key[1]
#     )

#     if new_student_batches.size >= 1000
#       Omr::StudentBatch.import new_student_batches, validate: false
#       new_student_batches.clear
#     end
#   end

#   Omr::StudentBatch.import new_student_batches, validate: false unless new_student_batches.empty?
# end