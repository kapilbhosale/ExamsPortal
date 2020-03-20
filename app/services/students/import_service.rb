class ImportError < StandardError; end

module Students
  class ImportService

    def initialize(csv_file_path, batch_id)
      @csv_file_path = csv_file_path
      @batch = Batch.find(batch_id)
    end

    def import
      CSV.open(@csv_file_path, :row_sep => :auto, :col_sep => ",") do |csv|
        csv.each do |row|
          roll_number = row[0]
          name = row[1]
          parent_mobile = row[2]

          email = "#{roll_number}@se.com"
          student = Student.find_or_initialize_by(email: email)
          student.roll_number = roll_number
          student.name = name

          rand_password = parent_mobile
          student.password = rand_password
          student.raw_password = rand_password
          student.parent_mobile = parent_mobile

          student.save
          StudentBatch.create(student: student, batch: @batch)
        end
      end
    end
  end
end
