Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions, only: %i[index show new create] do
    resources :answers, only: %i[create], shallow: true
  end
end
