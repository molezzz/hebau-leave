Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'cmc/dashboard' => 'cmc#index'
  post 'admin/login' => 'cmc#login'
  get 'user/info' => 'cmc#user_info'
end
