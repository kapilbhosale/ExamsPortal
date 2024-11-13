# file_path = '/Users/kapilbhosale/Downloads/test_zip/Student_Master.csv'
# Omr::ImportStudents.new(1, 'latur', file_path).call
class Omr::ImportStudents
  attr_reader :org_id, :branch, :file_path

  def initialize(org_id, branch, file_path)
    @org_id = org_id
    @branch = branch
    @file_path = file_path
  end

  def call
    csv_file = File.open(file_path, "r:ISO-8859-1")

    students_to_insert = []
    batch_size = 1000
    max_student_id = 50000

    begin
      CSV.foreach(csv_file, headers: true).each do |csv_row|
        student_id = csv_row['Student_ID']
        # next if student_id is not a number or its greater than max_student_id
        next if student_id.to_i.to_s != student_id || student_id.to_i >= max_student_id
        putc "."
        students_to_insert << {
          org_id: org_id,
          roll_number: csv_row['Student_Roll_No'],
          name: csv_row['FName'],
          parent_contact: csv_row['Parent_Contact'].to_s.strip,
          student_contact: csv_row['Contact'].to_s.strip,
          branch: branch,
          old_id: csv_row['Student_ID'].to_i
        }

        if students_to_insert.size >= batch_size
          insert_students(students_to_insert)
          students_to_insert.clear
        end
      end

      # Insert any remaining students
      insert_students(students_to_insert) unless students_to_insert.empty?
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
