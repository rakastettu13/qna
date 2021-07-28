Rails.application.routes.draw do
  resources :questions, only: %i[show new create] do
    resources :answers, only: %i[show new create], shallow: true
  end
end
