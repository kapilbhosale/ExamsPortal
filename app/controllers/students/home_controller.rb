class Students::HomeController < Students::BaseController
  before_action :authenticate_student!, except: [:tests]
  skip_before_action :verify_authenticity_token, only: [:sync, :submit]

  def index
    @styles = ''
  end

  def tests
  	@exams = Exam.all
    if current_student
      @student_exams = StudentExam.where(student: current_student)&.index_by(&:exam_id) || {}
    end
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
    @student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: @exam.id)
  end

  def sync
    student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: params[:exam_id])
  	params[:questions].each do |index, input_question|
      if input_question[:answerProps][:answer].to_i > 0
        student_exam_answer = StudentExamAnswer.find_by(student_exam_id: student_exam.id, question_id: input_question[:id])
        if student_exam_answer
  		    student_exam_answer.update!(option_id: input_question[:answerProps][:answer])
        else
           StudentExamAnswer.create!(student_exam_id: student_exam.id, question_id: input_question[:id], option_id: input_question[:answerProps][:answer])
        end
      end
  	end
  end

  def submit
    student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: params[:exam_id])
    render :ok unless student_exam
    student_exam.update!(ended_at: Time.current)
  end

  def exam_data
    exam_id =  params[:id]
    exam = Exam.find params[:id]
    student_id = current_student.id

    student_exam = StudentExam.find_by(student_id: student_id, exam_id: exam_id)
    unless student_exam
    	student_exam = StudentExam.create!(student_id: student_id, exam_id: exam_id, started_at: Time.current)
    end

    questions = exam.questions.map do |question|
    	{
    		id: question.id,
    		title: question.title,
    		options: question.options.map { |o| { id: o.id, data: o.data } },
        cssStyle: question.css_style,
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
      totalQuestions: exam.questions.size,
      questions: questions,
      startedAt: student_exam.started_at,
      timeInMinutes: exam.time_in_minutes,
      studentId: current_student.id,
    }
  end

  def profile
    @student = Student.find(current_student.id)
  end

  def update_profile
    @response = Students::UpdateStudentService.new(params, student_params).call
    set_flash
    redirect_to students_home_profile_path
  end

  private

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end

  def student_params
    params.require(:student).permit(
      :roll_number,
      :name,
      :mother_name,
      :date_of_birth,
      :gender,
      :ssc_marks,
      :student_mobile,
      :parent_mobile,
      :category_id,
      :address,
      :college,
      :photo)
  end
end
