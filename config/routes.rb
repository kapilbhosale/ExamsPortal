Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'students/home#tests'
  namespace :students do
    root to: 'home#index'
    get :tests, to: 'home#tests', as: :tests
    get :instructions, to: 'home#instructions', as: :exam_instructions
    get :confirmation, to: 'home#confirmation', as: :exam_confirmation
    get :subscription, to: 'home#subscription', as: :exam_subscription
    get :summary, to: 'home#summary', as: :exam_summary

    resources :mock_tests
  end
end
