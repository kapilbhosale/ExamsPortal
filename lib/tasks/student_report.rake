require 'csv'

namespace :student_report do
  task print: :environment do
    CSV.open("Students.csv","w") do |csv|
      csv << ['Roll Number', 'Student Name', 'Email', 'password', 'Batch']

      Student.all.each do |student|
        csv << [
          student.roll_number,
          student.name,
          student.email,
          student.raw_password,
          student.batches.pluck(:name).join(' | ')
        ]
      end
    end
    puts 'Done Generating CSV'
  end
end
