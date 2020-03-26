batch = Batch.find_or_create_by(name: 'Demo')
students = []

(1..500).each do |i|
  students << "#{i},DemoUser#{i},111111"
end

students.each do |row|
  data = row.split(',')
  email = "#{data[0]}-demo@se.com"
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
end
