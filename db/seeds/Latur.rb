batch = Batch.find_or_create_by(name: '12th-rep')
students = [
  "10003,Sarthak Ashok Khumkar,9822716262",
  "10006,Vaishnavi Sanjay Dhule,9763182355",
]
students.each do |row|
  data = row.split(',')
  email = "#{data[0]}-akola@se.com"
  student = Student.find_or_initialize_by(email: email)
  student.roll_number = data[0].strip
  rand_password = data[2].strip || '1'
  rand_password = '111111' if rand_password.length < 6
  student.password = rand_password
  student.raw_password = rand_password
  student.name = data[1].strip
  student.parent_mobile = rand_password
  student.save
  StudentBatch.create(student: student, batch: batch)
  puts "Adding student - #{email}"
end
