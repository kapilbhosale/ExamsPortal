# file_path = '/Users/kapilbhosale/Downloads/test_zip/Student_Master.csv'
# Omr::ImportStudents.new(1, 'Latur-12+rep', file_path).call
class Omr::ImportStudents
  attr_reader :org_id, :branch, :file_path

  def initialize(org_id, branch, file_path)
    @org_id = org_id
    @branch = branch
    @file_path = file_path
  end

  def call
    begin
      csv_file = File.open(file_path, "r:ISO-8859-1")
      max_student_id = 50000

      CSV.foreach(csv_file, headers: true).each do |csv_row|
        student_id = csv_row['Student_ID']
        # next if student_id is not a number or its greater than max_student_id
        next if student_id.to_i.to_s != student_id || student_id.to_i >= max_student_id

        student = Student.find_by(
          roll_number: csv_row['Student_Roll_No'],
          org_id: org_id,
          parent_mobile: csv_row['Parent_Contact'].to_s.strip,
          branch: branch
        )
        next if student.present?

        Student.create({
          org_id: org_id,
          roll_number: csv_row['Student_Roll_No'],
          name: csv_row['FName'],
          parent_contact: csv_row['Parent_Contact'].to_s.strip,
          student_contact: csv_row['Contact'].to_s.strip,
          branch: branch,
          old_id: csv_row['Student_ID'].to_i,
          deleted_at: csv_row['Is_Delete'] == 'True' ? Time.current : nil
        })
      end
    ensure
      csv_file.close
    end
  end

  private
  def insert_students(students)
    puts "Inserting #{students.size} students"
    Omr::Student.import(
      students,
      on_duplicate_key_ignore: true
    )
  end
end


# def process_student_master
#   file_path = "#{get_base_file_path}/Student_Master.csv"
#   csv_file = File.open(file_path, "r:ISO-8859-1")
#   CSV.foreach(csv_file, :headers => true).each do |csv_row|
#     # next if csv_row['Is_Delete'] == 'True'
#     student_id = csv_row['Student_ID']
#     # next if student_id is not a number or its greater than 50000
#     next if student_id.to_i.to_s != student_id || student_id.to_i >= 50000

#     omr_student = Omr::Student.find_by(id: student_id)
#     unless omr_student.present?
#       omr_student = Omr::Student.new
#       omr_student.org_id = 1
#       omr_student.id = csv_row['Student_ID'].to_i
#       omr_student.roll_number = csv_row['Student_Roll_No']
#       omr_student.name = csv_row['FName']
#       omr_student.parent_contact = csv_row['Parent_Contact'].to_s.strip
#       omr_student.student_contact = csv_row['Contact'].to_s.strip
#       omr_student.branch = branch
#       omr_student.save
#     end

#     if omr_student && omr_student.student_id.blank?
#       student = Student.find_by(roll_number: csv_row['Student_Roll_No'], org_id: 1, parent_mobile: omr_student.parent_contact)
#       if student.present?
#         omr_student.student_id = student.id
#         omr_student.save
#       end
#     end
#   end
# end