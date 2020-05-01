Rails.application.routes.draw do
  devise_for :admin
  devise_for :student

  # authenticate :admin, -> (admin) { admin.present? } do
  #   mount PgHero::Engine, at: "pghero"
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'students/home#index'

  namespace :students do
    get 'videos' => 'videos#lectures'
    get 'lectures' => 'videos#lectures'
    get 'lectures/:video_id' => 'videos#show_lecture'

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
    get "exam/:id", to: 'home#exam'
    put "sync/:exam_id/", to: 'home#sync'
    put "submit/:exam_id/", to: 'home#submit'
    resources :mock_tests
    get 'home/profile', to: 'home#profile'
    patch 'home/update_profile', to: 'home#update_profile'

    resources :model_answers
  end


  # routes of admin panel
  namespace :admin do
    root to: 'dashboard#show'
    resource :dashboard
    resources :reports
    resources :exams do
      collection do
        get 'question_bank', to: 'exams#question_bank'
        get 'new_jee', to: 'exams#new_jee'
      end
    end
    resources :practice_questions
    resources :students do
      root to: 'students#index'
      get :import, on: :collection
      post :process_import, on: :collection
    end
    resources :batches do
      root to: 'batches#index'
    end
    get 'dashboard/profile', to: 'dashboard#profile'
    patch 'dashboard/update_profile', to: 'dashboard#update_profile'
    resources :video_lectures
  end

  get 'current-server-time', to: 'home#current_server_time'





  namespace :api do
    namespace :v1 do
      post 'sign-in', to: 'students#login'
      post 'update-fcm-token', to: 'students#update_fcm_token'
      get 'dashboard_data', to: 'home#dashboard_data'
      get 'gallery', to: 'home#gallery'
      get 'app-version', to: 'home#app_version'

      resources :notifications, only: [:index]
      resources :videos, only: [:index]
      resources :study_pdfs, only: [:index]
    end
  end
end
