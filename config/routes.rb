Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :votable do
    member do
      patch :change_rating
      delete :cancel
    end
  end

  resources :attachments, only: :destroy
  resources :achievements, only: :index do
    collection do
      get :received
    end
  end

  resources :questions, except: :edit, concerns: :votable do
    resources :answers, only: %i[create update destroy], shallow: true, concerns: :votable do
      member do
        patch :best
      end
    end
  end
end
