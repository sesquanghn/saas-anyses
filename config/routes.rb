Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/auth'

  namespace :api do
    namespace :v1 do
      resource :users, only: [:create, :show]
      resources :leave_applications

      namespace :admin do
        resources :leave_applications
      end
    end
  end
end
