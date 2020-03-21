batch = Batch.find_or_create_by(name: 'JEE')
students = [
  "101,Demo user,1234567890",
  "102,Demo user,1234567890",
  "103,Demo user,1234567890",
  "104,Demo user,1234567890",
  "105,Demo user,1234567890",
  "106,Demo user,1234567890",
  "107,Demo user,1234567890",
  "108,Demo user,1234567890",
  "109,Demo user,1234567890",
  "110,Demo user,1234567890",
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
