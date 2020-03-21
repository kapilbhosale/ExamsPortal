batch = Batch.find_or_create_by(name: 'JEE')
students = [
  "211,Demo user,1234567890",
  "212,Demo user,1234567890",
  "213,Demo user,1234567890",
  "214,Demo user,1234567890",
  "215,Demo user,1234567890",
  "216,Demo user,1234567890",
  "217,Demo user,1234567890",
  "218,Demo user,1234567890",
  "219,Demo user,1234567890",  
  ]

students.each do |row|
  data = row.split(',')
  email = "#{data[0]}@se.com"
  student = Student.find_or_initialize_by(email: email)
  student.roll_number = data[0]
  rand_password = '111111'
  student.password = rand_password
  student.raw_password = rand_password
  student.name = data[1]
  student.parent_mobile = data[2]
  student.save
  StudentBatch.create(student: student, batch: batch)
  puts "Adding student - #{email}"
end
