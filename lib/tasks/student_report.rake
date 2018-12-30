require 'csv'

namespace :student_report do
  task student_list: :environment do
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

  task exam_report: :environment do

    results = {}
    StudentExamSummary.includes(:student_exam).where(student_exams: {exam_id: Exam.last.id}).all.group_by(&:student_exam_id).each do |student_exam_id, summary|
      summary.each do |s|
        results[student_exam_id] ||= {}
        results[student_exam_id][s.section_id] = {
          no_of_questions: s.no_of_questions,
          answered: s.answered,
          not_answered: s.not_answered,
          correct: s.correct,
          incorrect: s.incorrect,
          score: s.score
        }
      end
    end

    student_exams_by_id = StudentExam.includes(:student).all.index_by(&:id)
    data = {}
    results.each do |student_exam_id, result|
      data[student_exam_id] ||= {}
      data[student_exam_id][:roll_number] = student_exams_by_id[student_exam_id].student.roll_number
      data[student_exam_id][:name] = student_exams_by_id[student_exam_id].student.name
      data[student_exam_id][:batch] = student_exams_by_id[student_exam_id].student.batches.pluck(:name).first
      result.each do |section_id, res|
        data[student_exam_id][section_id] ||= res
      end
    end

    CSV.open("Result.csv","w") do |csv|
      csv << ['Roll Number', 'Student Name', 'Batch',
              'phy_no_of_questions', 'phy_answered', 'phy_not_answered', 'phy_correct', 'phy_incorrect', 'phy_score',
              'chem_no_of_questions', 'chem_answered', 'chem_not_answered', 'chem_correct', 'chem_incorrect', 'chem_score',
              'bio_no_of_questions', 'bio_answered', 'bio_not_answered', 'bio_correct', 'bio_incorrect', 'bio_score',
              'total_no_of_questions', 'answered', 'not_answered', 'correct', 'incorrect', 'total_score'
      ]
      data.each do |_, row|
        csv << [
          row[:roll_number],
          row[:name],
          row[:batch],
          row[2][:no_of_questions],
          row[2][:answered],
          row[2][:not_answered],
          row[2][:correct],
          row[2][:incorrect],
          row[2][:score],
          row[3][:no_of_questions],
          row[3][:answered],
          row[3][:not_answered],
          row[3][:correct],
          row[3][:incorrect],
          row[3][:score],
          row[5][:no_of_questions],
          row[5][:answered],
          row[5][:not_answered],
          row[5][:correct],
          row[5][:incorrect],
          row[5][:score],
          '180',
          row[2][:answered] + row[3][:answered] + row[5][:answered],
          row[2][:not_answered] + row[3][:not_answered] + row[5][:not_answered],
          row[2][:correct] + row[3][:correct] + row[5][:correct],
          row[2][:incorrect] + row[3][:incorrect] + row[5][:incorrect],
          row[2][:score] + row[3][:score] + row[5][:score]
        ]
      end
    end
    puts 'Done Generating CSV'
  end

end
