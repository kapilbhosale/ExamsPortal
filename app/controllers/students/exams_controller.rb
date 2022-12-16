class Students::ExamsController < Students::BaseController
  before_action :authenticate_student!, except: [:tests]
  skip_before_action :verify_authenticity_token, only: [:sync, :submit]
  layout 'student_exam_layout', only: [:exam]


  def print_hall_ticket
    # respond_to do |format|
    #   format.html
    #   format.pdf do
    #     render pdf: "Exam Hall Ticket",
    #           template: "students/exams/print_hall_ticket.pdf.erb",
    #           locals: {current_student: current_student },
    #           footer: { font_size: 9, left: DateTime.now.strftime("%d-%B-%Y %I:%M%p"), right: 'Page [page] of [topage]' }
    #   end
    # end
      # Create a new Prawn document

      pdf = Prawn::Document.new(:left_margin => 50)
      # Set the background image for the first page
      center = current_student.roll_number < 80_000 ? :latur : :nanded
      time = center == :nanded ? "18 Dec 2022, 10.00AM-1.20PM OR 3.00PM-6.20PM" : "18 Dec 2022, 2.00PM - 5.20PM"

      table_data = [
              [{content: 'Seat Number', font_style: :bold}, current_student.roll_number],
              [{content: 'Exam Center', font_style: :bold}, get_center(current_student.roll_number)],
              [{content: 'Candiate Name', font_style: :bold}, current_student.name],
              [{content: 'Date & Time', font_style: :bold}, time],
              [{content: 'Student Mobile', font_style: :bold}, current_student.student_mobile],
              [{content: 'Parent Mobile', font_style: :bold}, current_student.parent_mobile]
            ]

      pdf.canvas do
        pdf.image("app/assets/images/latur-hallticket-1.jpg", scale: 1, at: pdf.bounds.top_left)
        pdf.move_down 200
      end
      pdf.table table_data, row_colors: ["ffffff", "eeeeee"], cell_style: {height: 22, border_width: 0, width: 210, padding: [5, 0, 5, 20], text_color: '373737', inline_format: true} do
        # Aligning a specific column cells' text to right
        # columns(1).style = :bold
        column(0).width = 100
        column(-1).width = 320
       end

      pdf.start_new_page
      pdf.canvas do
        pdf.image("app/assets/images/#{center.to_s}-hallticket-2.jpg", scale: 1, at: pdf.bounds.top_left)
        pdf.text "This is the second page!"
      end
      send_data pdf.render, filename: "hallticket.pdf", type: "application/pdf"
  end

  def get_center(roll_number)
    return "Nalanda - 2, Latur" if roll_number < 21_198
    return "Nalanda - 3, Latur" if roll_number < 21_365
    return "Nalanda - 4, Latur" if roll_number < 21_532
    return "Nalanda - 5, Latur" if roll_number < 21_695
    return "Nalanda - 6, Latur" if roll_number < 22_024
    return "Nalanda - 7, Latur" if roll_number < 22_135
    return "Nalanda - 8, Latur" if roll_number < 22_329
    return "Nalanda - 9, Latur" if roll_number < 22_664
    return "Nalanda - 11, Latur" if roll_number < 22_774
    return "Nalanda - 12, Latur" if roll_number < 22_933
    return "RCC Hall - 1, Latur" if roll_number < 30_000


    return "Nalanda Campus - 01, Tilak Nagar, Nanded" if roll_number < 82_479
    return "Nalanda Campus - 02, Bhagya Nagar, Nanded" if roll_number < 99_000
  end

  def is_exam_valid
    exam_id = params[:id]
    student_id = current_student.id
    student_exam = StudentExam.find_by(student_id: student_id, exam_id: exam_id)
    if student_exam&.ended_at.present?
      render json: { error: 'Invalid exam or already submitted' } and return
    end
    render json: {}
  end

  def exam_data
    exam_id = params[:id]
    exam = Exam.find_by(id: exam_id)
    if exam.blank? || exam.show_exam_at > Time.current
      render json: { error: 'Invalid exam ID' } and return
    end
    student_id = current_student.id
    student_exam = StudentExam.find_by(student_id: student_id, exam_id: exam_id)
    if student_exam
      # this must be very rare case, when student changes the computer
      ses = StudentExamSync.find_by(student_id: student_id, exam_id: exam_id)
      if ses
        Students::SyncService.new(student_id, exam_id, ses.sync_data).call
        ses.destroy
      end
      student_answers_by_question_id =
        StudentExamAnswer.where(student_exam_id: student_exam.id)
        .where(question_id: exam_question_ids(exam_id)).index_by(&:question_id)
    else
      student_exam = StudentExam.create!(student_id: student_id, exam_id: exam_id, started_at: Time.current)
    end

    questions = exam_questions_with_options(exam_id)
    time_data = {
      startedAt: student_exam.started_at,
      currentTime: DateTime.current.iso8601,
      studentId: student_id
    }

    render json: {
      questions: questions,
      exam_type: exam.exam_type,
      student_ans: student_answers_by_question_id,
      time_data: time_data,
      model_ans: Exams::ModelAnsService.new(exam_id).call
    }
  end

  def exam_data_s3
    exam_id = params[:id]
    exam = Exam.find_by(id: exam_id)
    if exam.blank? || exam.show_exam_at > Time.current
      render json: { error: 'Invalid exam ID' }, status: 422 and return
    end

    student_id = current_student.id
    student_exam = StudentExam.find_by(student_id: student_id, exam_id: exam_id)
    if student_exam.blank?
      student_exam = StudentExam.create!(student_id: student_id, exam_id: exam_id, started_at: Time.current)
    end

    time_data = {
      startedAt: student_exam.started_at,
      currentTime: DateTime.current.iso8601,
      studentId: student_id
    }

    render json: {
      exam_type: exam.exam_type,
      student_ans: {},
      time_data: time_data,
      s3_url: "#{ENV.fetch('AWS_CLOUDFRONT_URL')}/json-data/#{Rails.env}-#{current_org.subdomain}-#{exam.id}.json"
    }
  end

  def exam_question_ids(exam_id)
    _exam_question_ids = REDIS_CACHE.smembers("exam_questions_ids_#{exam_id}")
    return _exam_question_ids if _exam_question_ids.present?

    exam = Exam.find exam_id
    _exam_question_ids = exam.questions.ids
    REDIS_CACHE.sadd("exam_questions_ids_#{exam_id}", _exam_question_ids)
    _exam_question_ids
  end

  def exam_questions_with_options(exam_id)
    cache_key = "exam_questions_#{exam_id}"
    questions_with_options = REDIS_CACHE.get(cache_key)
    return questions_with_options if questions_with_options.present?

    exam = Exam.find params[:id]
    indexed_questions = exam.questions.includes(:options, :section).index_by(&:id)

    questions = exam.questions.order(:id).includes(:options).map do |question|
      {
        id: question.id,
        title: question.title,
        is_image: question.is_image,
        question_type: question.question_type,
        options: question.options.map { |o| { id: o.id, data: o.data, is_image: o.is_image } }.sort_by{ |o| o[:id] },
        cssStyle: ""
      }
    end

    questions_by_sections = {}
    questions.each do |question|
      db_question = indexed_questions[question[:id]]
      questions_by_sections[db_question.section.name] ||= []
      questions_by_sections[db_question.section.name] << question
    end

    questions_with_options = {
      currentQuestionIndex: questions_by_sections.keys.inject({}) { |h, k| h[k] = 0; h },
      totalQuestions: questions_by_sections.inject({}) { |h, k| h[k[0]] = k[1].size; h },
      questionsBySections: questions_by_sections,
      sections: questions_by_sections.keys,
      # startedAt: student_exam.started_at,
      # currentTime: DateTime.current.iso8601,
      timeInMinutes: exam.time_in_minutes,
      # studentId: current_student.id
    }
    REDIS_CACHE.set(cache_key, questions_with_options.to_json)
    # deliberately doing it to keep consistent return data type
    # questions_with_options
    REDIS_CACHE.get(cache_key)
  end
end

