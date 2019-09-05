Rails.application.routes.draw do
  namespace :api do 
    scope :v1 do 
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }
    end
  end

  namespace :api do 
    namespace :v1 do 
      resources :products do
        member do
          post :trade, :complete
          get '/trade', to: 'products#trading'
        end
        collection do
          get '/search', to: 'products#search'
        end
        resource :likes, only: [:create, :destroy]
        resources :comments, only: [:create, :destroy]
        resources :trade_messages, only: [:create, :destroy]
      end

      scope '/user' do
        get '/like', to: 'users#like'
        get '/sell', to: 'users#sell'
        get'/purchase', to: 'users#purchase'
        post '/bank', to: 'users#bank'
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
