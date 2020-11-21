Rails.application.routes.draw do
  root to: 'cocktails#index'

  resources :cocktails, only: %i[index show new create] do
    resources :doses, only: %i[new create]
  end
  resources :doses, only: :destroy
end
