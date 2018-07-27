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
  end

  def exam_data
    puts "params: \n\n--------- #{params.inspect}"

    exam_id =  params[:id]
    exam = Exam.find params[:id]
    student_id = params[:student_id] || 1

    student_exam = StudentExam.find_by(student_id: student_id, exam_id: exam_id)
    unless student_exam
    	student_exam = StudentExam.create!(student_id: student_id, exam_id: exam_id, started_at: Time.current)
    end

    questions = exam.questions.map do |question|
    	{
    		title: question.title,
    		options: question.options.map { |o| o.data },
    		answerProps: {
          isAnswered: false,
          visited: false,
          needReview: false,
          answer: 1
        }
    	}
    end

    render json: {
      currentQuestionIndex: 0,
      totalQuestions: exam.no_of_questions,
      questions: questions,
      startedAt: student_exam.started_at
    }
  end
end
