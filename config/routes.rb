Rails.application.routes.draw do
  devise_for :admin
  devise_for :student
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'students/home#tests'

  namespace :students do
    root to: 'home#index'
    get :tests, to: 'home#tests', as: :tests
    get :instructions, to: 'home#instructions', as: :exam_instructions
    get :confirmation, to: 'home#confirmation', as: :exam_confirmation
    get :subscription, to: 'home#subscription', as: :exam_subscription
    get "summary/:exam_id", to: 'home#summary', as: :exam_summary
    get :exam_data, to: 'home#exam_data'
    get "exam/:id", to: 'home#exam'
    get "sync/:exam_id/", to: 'home#sync'
    get "submit/:exam_id/", to: 'home#submit'
    resources :mock_tests
  end


  # routes of admin panel
  namespace :admin do
    root to: 'dashboard#show'
    resource :dashboard
    resources :reports
    resources :exams
    resources :practice_questions
    resources :students do
      root to: 'students#index'
    end
    resources :batches do
      root to: 'batches#index'
    end
  end
end
