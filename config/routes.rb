Rails.application.routes.draw do
  root to: 'cocktails#index'

  devise_for :users
  resources :ingredients, shallow: true

  resources :cocktails, shallow: true do
    resources :reviews, except: :index, shallow: true
    resources :doses, except: :index, shallow: true
  end
end
