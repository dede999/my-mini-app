Rails.application.routes.draw do
  resources :task, except: [:index, :create]
  resources :lists do
    resources :task, only: [:index, :create]
  end
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
