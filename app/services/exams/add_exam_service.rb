class AddExamError < StandardError; end

module Exams
  class AddExamService
    attr_reader :params, :name, :batch_ids, :current_org
    def initialize(params, current_org)
      @params = params
      @name = params[:name]
      @current_org = current_org
    end

    def create
      validate_request
      @batch_ids = params[:exam][:batches]
      shuffle_questions = params[:shuffle_questions] == 'on'
      ActiveRecord::Base.transaction do
        @exam = Exam.new(exam_params.merge!(shuffle_questions: shuffle_questions))

        # set org id to exams
        @exam.org_id = current_org.id

        if params[:exam_type]
          e_type = Exam.exam_types[params[:exam_type].to_sym]
          @exam.exam_type = e_type
        end
        build_batches
        if @exam.save!
          params[:questions_zip].each do |section_id, zip_file|
            marks = {
              positive_marks: params.dig(:positive_marks, section_id) || 4,
              negative_marks: params.dig(:negative_marks, section_id) || -1
            }
            Exams::Upload.new(@exam, zip_file.tempfile, section_id, marks).call
          end

          # upload exam json to S3
          upload_exam_json_to_s3

          return {status: true, message: 'Exam added successfully'}
        end
      end
    rescue AddExamError, ActiveRecord::RecordInvalid => ex
      return { status: false, message: ex.message }
    end

    private

    def upload_exam_json_to_s3
      file_name = "json-data/#{Rails.env}-#{current_org.subdomain}-#{@exam.id}.json"
      s3 = Aws::S3::Resource.new(
        access_key_id: ENV.fetch('AWS_KEY_ID'),
        secret_access_key: ENV.fetch('AWS_SECRET'),
        region: 'ap-south-1'
      )
      # s3.client.put_bucket_acl(acl: "public-read",bucket: 'smart-exams-production')
      # bucket = s3.bucket('smart-exams-production')
      s3.client.put_object(
        bucket: 'smart-exams-production',
        key: file_name,
        body: exam_json_data.to_json,
        acl: "public-read"
      )
    end

    def exam_json_data
      {
        exam_type: @exam.exam_type,
        questions: exam_questions_with_options(@exam.id),
        model_ans: Exams::ModelAnsService.new(@exam.id).call
      }
    end

    def validate_request
      raise AddExamError, 'Name must be present' if name.nil?
      raise AddExamError, 'Name already taken' if name_already_taken?
      raise AddExamError, 'Select ZIP file to upload questions' if params[:questions_zip].nil?
      raise AddExamError, 'At least one batch must be selected' if params[:exam].nil?
    end

    def name_already_taken?
      Exam.find_by(name: name).present?
    end

    def exam_params
      params.permit(:name,
                    :description,
                    :no_of_questions,
                    :time_in_minutes,
                    :publish_result,
                    :questions_zip,
                    :show_exam_at,
                    :show_result_at,
                    :exam_available_till,
      )
    end

    def build_batches
      @batch_ids&.each do |batch|
        @exam.exam_batches.build(exam_id: @exam.id, batch_id: batch.to_i)
      end
    end

    def exam_questions_with_options(exam_id)
      cache_key = "exam_questions_#{exam_id}"
      questions_with_options = REDIS_CACHE.get(cache_key)
      return questions_with_options if questions_with_options.present?

      exam = Exam.find exam_id
      indexed_questions = exam.questions.order(:id).includes(:options, :section).index_by(&:id)

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
end
