Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions, only: %i[index show new create update destroy] do
    resources :answers, only: %i[create update destroy], shallow: true do
      member do
        patch :best
      end
    end
  end
end
