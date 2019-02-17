Rails.application.routes.draw do
  resources :records
  resources :users
  resource :wechat, only: [:show, :create]
  resources :positions
  resources :departments
  resources :admins
  post 'admin_token' => 'admin_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'cmc/dashboard' => 'cmc#index'
  post 'admin/logout' => 'cmc#logout'
  get 'user/info' => 'cmc#user_info'
end
