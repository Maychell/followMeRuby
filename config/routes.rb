Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'home#index'

  namespace :api do
    namespace :v1 do
      resources :sign_in, only: :create
    end
  end
end
