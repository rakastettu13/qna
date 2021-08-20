Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :attachments, only: :destroy

  resources :questions, except: :edit do
    resources :answers, only: %i[create update destroy], shallow: true do
      member do
        patch :best
      end
    end
  end
end
