batch = Batch.find_or_create_by(name: 'JEE')
students = [
  "111,Demo user,1234567890",
  "112,Demo user,1234567890",
  "113,Demo user,1234567890",
  "114,Demo user,1234567890",
  "115,Demo user,1234567890",
  "116,Demo user,1234567890",
  "117,Demo user,1234567890",
  "118,Demo user,1234567890",
  "119,Demo user,1234567890",
  "120,Demo user,1234567890",
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
