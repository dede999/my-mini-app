Rails.application.routes.draw do
  put '/edit', to: 'user_actions#edit_user'
  get '/followed_lists', to: 'user_actions#show_followed_lists'
  resources :task, except: [:index, :create]
  resources :lists do
    post '/follow', to: 'user_actions#follow_a_list'
    delete '/unfollow', to: 'user_actions#unfollow_a_list'
    resources :task, only: [:index, :create]
  end
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
