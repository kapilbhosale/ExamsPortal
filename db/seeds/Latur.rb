batch = Batch.find_or_create_by(name: 'Latur-12')
students = [
  "21000,Bharat Pate  ,9763660002",
  "23000,Shri Ganesh  ,9096330327",
  "45056,Nagare Yuthika Devendra  ,9422473504"
]
students.each do |row|
  data = row.split(',')
  email = "#{data[0]}-latur@se.com"
  student = Student.find_or_initialize_by(email: email)
  student.roll_number = data[0]
  rand_password = data[2]
  rand_password = '111111' if rand_password.length < 6
  student.password = rand_password
  student.raw_password = rand_password
  student.name = data[1]
  student.parent_mobile = data[2]
  student.save
  StudentBatch.create(student: student, batch: batch)
  puts "Adding student - #{email}"
end
