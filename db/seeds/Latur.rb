def add_students(students, batch)
  students.each do |row|
    data = row.split(',')
    email = "#{data[0]}-dhote-#{batch.name}@se.com"
    student = Student.find_or_initialize_by(email: email)
    student.roll_number = data[0].strip
    rand_password = data[2]&.strip || '1'
    rand_password = '111111' if rand_password.length < 6
    student.password = rand_password
    student.raw_password = rand_password
    student.name = data[1]&.strip
    student.parent_mobile = rand_password
    student.save
    StudentBatch.create(student: student, batch: batch)
    puts "Adding student - #{email}"
  end
end

batch = Batch.find_or_create_by(name: 'crash-course')
students = [
  "17001,Dr. Dhote Sir,9049106124",
"17002,Jagtap Sohan Subhash,9423532475",
]
add_students(students, batch);
