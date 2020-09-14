Rails.application.routes.draw do
  devise_for :super_admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :admin
  devise_for :student

  mount ActionCable.server => '/cable'

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'kapil' && password == 'kapil@7588584810'
  end
  mount Sidekiq::Web => '/sidekiq'

  # authenticate :admin, -> (admin) { admin.present? } do
  #   mount PgHero::Engine, at: "pghero"
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'students/home#index'

  get 'new-admission', to: 'students/admissions#show'
  get 'admission-done', to: 'students/admissions#admission_done'
  post 'admission-done', to: 'students/admissions#admission_done'
  post 'ADMISSION-DONE', to: 'students/admissions#admission_done'
  get 'ADMISSION-DONE', to: 'students/admissions#admission_done'
  get 'print-receipt/:reference_id', to: 'students/admissions#print_receipt'

  get 'pay-installment', to: 'students/admissions#pay_installment'

  namespace :students do
    get 'videos' => 'videos#lectures'
    get 'lectures' => 'videos#lectures'
    get 'lectures/:video_id' => 'videos#show_lecture'
    get 'yt-player' => 'videos#play_yt'
    get 'play-yt-video' => 'videos#play_yt_video'

    post 'authorise', to: 'login#authorise'
    get "auto-auth", to: 'home#auto_auth'
    root to: 'home#index'
    get :tests, to: 'home#tests', as: :tests
    get :instructions, to: 'home#instructions', as: :exam_instructions
    get :confirmation, to: 'home#confirmation', as: :exam_confirmation
    get :question_bank, to: 'home#question_bank', as: :question_bank
    get :subscription, to: 'home#subscription', as: :exam_subscription
    get "summary/:exam_id", to: 'home#summary', as: :exam_summary
    # get :exam_data, to: 'home#exam_data'
    get :exam_data, to: 'exams#exam_data'
    get :exam_data_s3, to: 'exams#exam_data_s3'
    get :is_exam_valid, to: 'exams#is_exam_valid'
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
      end
    end
    resources :practice_questions
    resources :students do
      root to: 'students#index'
      get :import, on: :collection
      post :process_import, on: :collection
      get :reset_login
      get :progress_report
    end
    resources :batches do
      root to: 'batches#index'
    end
    get 'dashboard/profile', to: 'dashboard#profile'
    patch 'dashboard/update_profile', to: 'dashboard#update_profile'

    resources :video_lectures do
      get :chats
      get :student_video_views
      get :modity_student_views
    end
    resources :android_apps
    resources :study_pdfs
    resources :notifications
    resources :genres do
      get :hide
      get :show
    end
    resources :study_pdf_types
    resources :messages
    resources :zoom_meetings do
      get :chats
    end
    resources :subjects
  end

  get 'current-server-time', to: 'home#current_server_time'

  namespace :api do
    namespace :v1 do
      post 'sign-in', to: 'students#login'
      post 'update-fcm-token', to: 'students#update_fcm_token'
      get 'dashboard_data', to: 'home#dashboard_data'
      get 'gallery', to: 'home#gallery'
      get 'app-version', to: 'home#app_version'
      get 'categories', to: 'videos#categories'
      get 'categories/:id/videos', to: 'videos#category_videos'

      resources :notifications, only: [:index]
      resources :videos, only: [:index] do
        get   :get_yt_url
        post  :set_yt_url
        get   :set_view_count
      end
      resources :study_pdfs, only: [:index]
      resources :meetings, only: [:index]
      resources :trackers
    end
  end
end
