Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      get 'current_user', to: 'users#current_user_info'
      
      resources :messages, only: [:index, :create, :destroy] do
        post :restore, on: :member
      end
      
      resources :users, only: [:index, :show]
      delete 'conversations/:user_id', to: 'conversations#destroy'
    end
  end
end