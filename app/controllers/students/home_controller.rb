class Students::HomeController < ApplicationController
  def index
    @styles = ''
  end

  def tests
  	@exams = Exam.all
  end

  def exam
  end

  def instructions
  	@exam_id = params[:exam_id]
  end

  def confirmation
    @exam = Exam.find_by(id: params[:exam_id])
  end

  def subscription
  end

  def summary
    @exam = Exam.find params[:exam_id]
    @student_exam = StudentExam.find_by(student_id: 1, exam_id: @exam.id)
  end

  def sync
    student_exam = StudentExam.find_by(student_id: params[:student_id] || 1, exam_id: params[:exam_id])
  	params[:questions].each do |index, input_question|
  		student_exam_answer = StudentExamAnswer.find_or_create_by!(student_exam_id: student_exam.id, question_id: input_question[:id])
  		student_exam_answer.update!(option_id: input_question[:answerProps][:answer])
  	end
  end

  def submit
    student_exam = StudentExam.find_by(student_id: params[:student_id] || 1, exam_id: params[:exam_id])
    render :ok unless student_exam
    student_exam.update!(ended_at: Time.current)
  end

  def exam_data
    exam_id =  params[:id]
    exam = Exam.find params[:id]
    student_id = params[:student_id] || 1

    student_exam = StudentExam.find_by(student_id: student_id, exam_id: exam_id)
    unless student_exam
    	student_exam = StudentExam.create!(student_id: student_id, exam_id: exam_id, started_at: Time.current)
    end

    questions = exam.questions.map do |question|
    	{
    		id: question.id,
    		title: question.title,
    		options: question.options.map { |o| { id: o.id, data: o.data } },
    		answerProps: {
          isAnswered: false,
          visited: false,
          needReview: false,
          answer: StudentExamAnswer.find_by(question_id: question.id, student_exam_id: student_exam.id)&.option_id
        }
    	}
    end

    render json: {
      currentQuestionIndex: 0,
      totalQuestions: exam.no_of_questions,
      questions: questions,
      startedAt: student_exam.started_at,
      timeInMinutes: exam.time_in_minutes,
    }
  end
end
