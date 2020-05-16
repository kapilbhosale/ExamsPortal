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
        return { error: "must have only 3 columns" } if csv.first.length != 3
        csv.each do |row|
          roll_number = row[0]&.strip
          name = row[1]&.strip
          rand_password = row[2]&.strip || '1'
          email = "#{roll_number}-client-#{batch.name.parameterize}@se.com"
          student = Student.find_or_initialize_by(email: email)
          student.roll_number = roll_number
          student.name = name

          rand_password = '111111' if rand_password.length < 6
          student.password = rand_password
          student.raw_password = rand_password
          student.parent_mobile = rand_password

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
