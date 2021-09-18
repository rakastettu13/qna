Rails.application.routes.draw do
  use_doorkeeper

  root to: 'questions#index'

  devise_for :users

  concern :votable do
    member do
      patch :change_rating
      delete :cancel
    end
  end

  concern :commentable do
    resource :comments, only: :create, shallow: true
  end

  resources :attachments, only: :destroy
  resources :achievements, only: :index do
    collection do
      get :received
    end
  end

  resources :questions, except: :edit, concerns: %i[votable commentable] do
    resources :answers, only: %i[create update destroy], shallow: true, concerns: %i[votable commentable] do
      member do
        patch :best
      end
    end
  end
end
