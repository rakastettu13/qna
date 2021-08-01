Rails.application.routes.draw do
  resources :questions, only: %i[index show new create] do
    resources :answers, only: %i[create], shallow: true
  end
end
