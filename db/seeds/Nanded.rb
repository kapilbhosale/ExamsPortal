batch = Batch.find_or_create_by(name: 'Nanded-12')
students = [
  "21001,Diwate Ganesh Subhash  ,9834659862"
]


students.each do |row|
  data = row.split(',')
  email = "#{data[0]}-nanded@se.com"
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
