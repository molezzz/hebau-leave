Rails.application.routes.draw do
  resources :records do
    member do
      put :back
      put :approval
    end
    collection do
      get :unreviewed
    end
  end
  resources :users do 
    collection do
      post :login
      get :record_count, to: 'records#count'
    end
  end
  resource :wechat, only: [:show, :create]
  resources :positions
  resources :departments
  resources :admins
  post 'admin_token' => 'admin_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'cmc/dashboard' => 'cmc#index'
  post 'admin/logout' => 'cmc#logout'
  get 'user/info' => 'cmc#user_info'
  post 'assess/votes' => 'assess#save_votes'
  post 'assess/generate_codes' => 'assess#generate_codes'
  post 'assess/send_codes' => 'assess#send_codes'
  get 'assess/send_code_list' => 'assess#send_code_list'
  get 'assess(/:code)' => 'assess#index'
end
