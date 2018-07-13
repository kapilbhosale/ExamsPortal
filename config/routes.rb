Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :students do
    root to: 'home#index'
    get :tests, to: 'home#tests', as: :tests
    get :instructions, to: 'home#instructions', as: :exam_instructions
    get :confirmation, to: 'home#confirmation', as: :exam_confirmation
    get :subscription, to: 'home#subscription', as: :exam_subscription
  end
end
