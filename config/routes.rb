Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api do
    namespace :v1 do
      resource :users, only: [:create, :show]

      resources :leave_applications
    end
  end
end
