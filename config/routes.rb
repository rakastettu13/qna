Rails.application.routes.draw do
  root to: 'questions#index'
  use_doorkeeper
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
    get :received, on: :collection
  end

  resources :questions, except: :edit, concerns: %i[votable commentable] do
    resources :answers, only: %i[create update destroy], shallow: true, concerns: %i[votable commentable] do
      patch :best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: :index
    end
  end
end
