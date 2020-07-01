class ImportError < StandardError; end

module Students
  class ImportService
    attr_reader :batch, :org

    def initialize(csv_file_path, batch_id, org)
      @csv_file_path = csv_file_path
      @batch = Batch.find(batch_id)
      @org = org
    end

    def import
      @students_added = []
      return { error: "Batch not found" } if batch.blank?

      CSV.open(@csv_file_path, :row_sep => :auto, :encoding => 'ISO-8859-1', :col_sep => ",") do |csv|
        return { error: "must have only 4 columns" } if csv.first.length != 4

        csv.each do |row|
          roll_number = row[0]&.strip
          name = row[1]&.strip
          rand_password = row[2]&.strip || '1'
          rand_password = '111111' if rand_password.length < 6
          student_mobile = row[3]&.strip || '1234567890'

          email = "#{roll_number}-#{rand_password}@se.com"
          student = Student.find_or_initialize_by(email: email)
          student.roll_number = roll_number
          student.name = name

          student.password = rand_password
          student.raw_password = rand_password
          student.parent_mobile = rand_password
          student.student_mobile = student_mobile

          student.org = org
          student.save
          StudentBatch.create(student: student, batch: batch)
          @students_added << student
        end
      end
      { data: @students_added.count }
    end
  end
end
