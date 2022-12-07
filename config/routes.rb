Rails.application.routes.draw do
  devise_for :super_admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :admin
  devise_for :student

  mount ActionCable.server => '/cable'

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'kapil' && password == 'kapil@7588584810'
  end
  mount Sidekiq::Web => '/sidekiq'

  post 'sync-attendance', to: 'admin/api/attendance#create'
  get  'machines', to: 'admin/api/attendance#machines'
  # mount PgHero::Engine, at: "/pg-stats-k"

  # authenticate :admin, -> (admin) { admin.present? } do
  #   mount PgHero::Engine, at: "pghero"
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'students/home#index'

  get  'pay/:slug', to: 'pay#show'
  post 'pay', to: 'pay#create', as: :pay_path
  post 'process-pay', to: 'pay#process_pay', as: :pay_process_path
  post 'auth-pay', to: 'pay#auth_pay', as: :pay_auth_path

  post 'process-gform', to: 'students/google_forms#register'

  get 'new-admission', to: 'students/admissions#show'
  get 'foundation-admission', to: 'students/admissions#foundation_show'
  get 'admission-done', to: 'students/admissions#admission_done'
  post 'admission-done', to: 'students/admissions#admission_done'
  post 'ADMISSION-DONE', to: 'students/admissions#admission_done'
  get 'ADMISSION-DONE', to: 'students/admissions#admission_done'
  get 'admission-done-set/:id', to: 'students/admissions#admission_done_set', as: :rcc_set_path

  # added for razorpay
  get 'initiate_pay', to: 'students/payments#initiate_pay', as: :initiate_pay
  post 'process-admission', to: 'students/payments#process_payment'
  post 'authorize_payment', to: 'students/payments#authorize_payment'
  get  'process-admission', to: 'students/payments#process_payment'
  get  'confirm_payment', to: 'students/payments#confirm_payment'

  get 'print-receipt/:reference_id', to: 'students/admissions#print_receipt'

  get 'pay-installment', to: 'students/admissions#pay_installment'
  get 'pay-due-fees', to: 'students/admissions#pay_due_fees'
  get 'pay_due_fees', to: 'students/admissions#pay_due_fees'

  namespace :students do
    get 'videos' => 'videos#lectures'
    get 'lectures' => 'videos#lectures'
    get 'lectures/:video_id' => 'videos#show_lecture'
    get 'category_videos/:id' => 'videos#category_videos'
    get 'yt-player' => 'videos#play_yt'
    get 'play-yt-video' => 'videos#play_yt_video'
    get 'otp_input', to: 'login#otp_input'
    post 'process_otp', to: 'login#process_otp'

    post 'authorise', to: 'login#authorise'
    get "auto-auth", to: 'home#auto_auth'
    root to: 'home#index'
    get :tests, to: 'home#tests', as: :tests
    get :progress_report, to: 'home#progress_report', as: :progress_report
    get :instructions, to: 'home#instructions', as: :exam_instructions
    get :confirmation, to: 'home#confirmation', as: :exam_confirmation
    get :question_bank, to: 'home#question_bank', as: :question_bank
    get :subscription, to: 'home#subscription', as: :exam_subscription
    get "summary/:exam_id", to: 'home#summary', as: :exam_summary
    # get :exam_data, to: 'home#exam_data'
    get :exam_data, to: 'exams#exam_data'
    get :exam_data_s3, to: 'exams#exam_data_s3'
    get :is_exam_valid, to: 'exams#is_exam_valid'
    get :print_hall_ticket, to: 'exams#print_hall_ticket'
    get "exam/:id", to: 'home#exam'
    put "sync/:exam_id/", to: 'home#sync'
    put "submit/:exam_id/", to: 'home#submit'
    resources :mock_tests
    get 'home/profile', to: 'home#profile'
    patch 'home/update_profile', to: 'home#update_profile'

    resources :model_answers
    resources :admissions do
      post :create_installment, on: :collection
    end
    resources :study_pdfs
    resources :notifications
    resources :progress_cards
    resources :messages
    resources :live_classes
  end


  # routes of admin panel
  namespace :admin do
    root to: 'dashboard#show'
    resource :dashboard
    resources :reports do
      get :exam_detailed_report
      get :generate_progress_report
    end
    resources :exams do
      collection do
        get 'question_bank', to: 'exams#question_bank'
        get 'new_jee', to: 'exams#new_jee'
        post 'change_question_answer'
        post :create_section
      end
      get :re_evaluate_exam
    end
    resources :practice_questions
    resources :students do
      root to: 'students#index'
      get :import, on: :collection
      post :process_import, on: :collection
      post :process_import_fees_due, on: :collection
      get :reset_login
      get :disable
      get :enable
      get :progress_report
    end
    resources :batches do
      root to: 'batches#index'
      get :disable
      get :change_batches, on: :collection
      post :process_change_batches, on: :collection
    end
    resources :batch_groups

    get 'dashboard/profile', to: 'dashboard#profile'
    patch 'dashboard/update_profile', to: 'dashboard#update_profile'

    resources :video_lectures do
      get :chats
      get :student_video_views
      get :modity_student_views
    end
    resources :android_apps
    resources :users do
      get :profile, on: :collection
    end
    resources :study_pdfs
    resources :notifications
    resources :genres do
      get :hide
      get :show
      put :student_folder_access
    end
    resources :study_pdf_types
    resources :messages
    resources :zoom_meetings do
      get :chats
    end
    resources :subjects
    resources :omr
    resources :attendance do
      get :overview_report, on: :collection
      get :settings, on: :collection
      get :sms_logs, on: :collection
    end

    resources :micro_payments
    resources :banners
    resources :att_machines do
      patch :enable
      patch :disable
    end

    namespace :api do
      resources :students
      resources :attendance
      resources :demo_logins
    end
  end

  get 'current-server-time', to: 'home#current_server_time'

  namespace :api do
    namespace :v1 do
      post 'sign-in', to: 'students#login'
      post 'update-fcm-token', to: 'students#update_fcm_token'
      get  'is-form-registered', to: 'students#is_form_registered'
      get 'dashboard_data', to: 'home#dashboard_data'
      get 'gallery', to: 'home#gallery'
      get 'app-version', to: 'home#app_version'
      get 'categories', to: 'videos#categories'
      get 'categories/:id/videos', to: 'videos#category_videos'

      resources :notifications, only: [:index]
      resources :videos, only: [:index] do
        get   :get_yt_url
        post  :set_yt_url
        get   :need_url
        get   :get_ytdlp_url
      end
      resources :study_pdfs, only: [:index]
      resources :meetings, only: [:index]
      resources :trackers
    end

    # NEW ROUTES
    namespace :v2 do
      resources :students, only: [:index] do
        post 'login', on: :collection
        get :progress_report, on: :collection
      end
      resources :notifications, only: [:index] do
        get :filter_types, on: :collection
      end
      resources :exams
    end
  end
end
