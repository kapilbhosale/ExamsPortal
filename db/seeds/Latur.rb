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

# [19, "Latur_11th_chem_2020"],
# [20, "Latur_11th_phy_2020"],
# [21, "Latur_11th_Bio_2020"],
# [22, "Latur_11th_PCB_2020"],

# [23, "Nanded_11th_chem_2020"],
# [24, "Nanded_11th_Phy_2020"],
# [25, "Nanded_11th_Bio_2020"],
# [26, "Nanded_11th_PCB_2020"]

# def get_batches(rcc_branch, course)
#   if rcc_branch == "latur"
#     return Batch.where(name: 'Latur_11th_PCB_2020') if course.name == 'pcb'
#     return Batch.where(name: 'Latur_11th_phy_2020') if course.name == 'phy'
#     return Batch.where(name: 'Latur_11th_chem_2020') if course.name == 'chem'
#     return Batch.where(name: 'Latur_11th_Bio_2020') if course.name == 'bio'
#     return Batch.where(name: ['Latur_11th_phy_2020', 'Latur_11th_chem_2020']) if course.name == 'pc'
#     return Batch.where(name: ['Latur_11th_phy_2020', 'Latur_11th_Bio_2020']) if course.name == 'pb'
#     return Batch.where(name: ['Latur_11th_chem_2020', 'Latur_11th_Bio_2020']) if course.name == 'cb'
#   else
#     return Batch.where(name: 'Nanded_11th_PCB_2020') if course.name == 'pcb'
#     return Batch.where(name: 'Nanded_11th_Phy_2020') if course.name == 'phy'
#     return Batch.where(name: 'Nanded_11th_chem_2020') if course.name == 'chem'
#     return Batch.where(name: 'Nanded_11th_Bio_2020') if course.name == 'bio'
#     return Batch.where(name: ['Nanded_11th_Phy_2020', 'Latur_11th_chem_2020']) if course.name == 'pc'
#     return Batch.where(name: ['Nanded_11th_Phy_2020', 'Latur_11th_Bio_2020']) if course.name == 'pb'
#     return Batch.where(name: ['Nanded_11th_chem_2020', 'Latur_11th_Bio_2020']) if course.name == 'cb'
#   end
# end

# s_ids = StudentBatch.where(batch_id: [19,20,21,22, 23,24,25,26]).pluck(:student_id)
# Student.where(id: s_ids).count

# org = Org.first
# roll_number = 60000
# NewAdmission.where(error_code: ['E000', 'E006']).each do |na|
#   email = "#{roll_number}-#{na.id}-#{na.parent_mobile}@rcc.com"

#   student = Student.find_or_initialize_by(email: email)
#   student.roll_number = roll_number
#   student.name = na.name
#   student.mother_name = "-"
#   student.gender = na.gender == 'male' ? 0 : 1
#   student.student_mobile = na.student_mobile
#   student.parent_mobile = na.parent_mobile
#   student.category_id = 1
#   student.password = na.parent_mobile
#   student.raw_password = na.parent_mobile
#   student.org_id = org.id
#   student.save

#   student.batches << get_batches(na.rcc_branch, na.course)
#   roll_number = Student.suggest_roll_number(org)
# end


# SMS_USER_NAME = "divyesh92@yahoo.com"
# SMS_PASSWORD = "myadmin"

# def sms_text(student)
#   "Dear Students, Welcome in the world of  RCC.

#   Your admission is confirmed.

#   Name: #{student.name}
#   Course: #{student.batches.pluck(:name).join(",")}

#   your Login details are
#   Roll Number: #{student.roll_number}
#   Parent Mobile: #{student.parent_mobile}

#   Download App from given link
#   https://play.google.com/store/apps/details?id=com.at_and_a.rcc_new"
# end

# def send_sms(student)
#   require 'net/http'
#   strUrl = "https://www.businesssms.co.in/SMS.aspx"; # Base URL
#   strUrl = strUrl+"?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91"+student.parent_mobile+"&Text="+sms_text(student)+"";
#   uri = URI(strUrl)
#   puts Net::HTTP.get(uri)

#   strUrl = "https://www.businesssms.co.in/SMS.aspx"; # Base URL
#   strUrl = strUrl+"?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo="+student.student_mobile+"&Text="+sms_text(student)+"";
#   uri = URI(strUrl)
#   puts Net::HTTP.get(uri)
# end


# Student.where(id: s_ids).includes(:batches).find_each do |student|
#   send_sms(student)
# end