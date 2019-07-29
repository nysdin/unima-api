Rails.application.routes.draw do
  namespace :api do 
    scope :v1 do 
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end

  namespace :api do 
    namespace :v1 do 
      resources :products do
        member do
          post :trade, :complete
        end
        resource :likes, only: [:create, :destroy]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
