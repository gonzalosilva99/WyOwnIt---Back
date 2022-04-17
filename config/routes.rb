Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope :api, defaults: { format: :json } do
    scope :v1 do
      devise_for :customers, skip: :all
      devise_scope :customer do
        post '/users/sign_in', to: 'api/v1/users/sessions#create'
        delete '/users/sign_out', to: 'api/v1/users/sessions#destroy'
        post '/users/sign_up', to: 'api/v1/users/registrations#create'
        post '/users/password', to: 'api/v1/users/passwords#create'
        put '/users/password', to: 'api/v1/users/passwords#update'
        get '/users/my_user', to: 'api/v1/users/users#my_user'
      end

      devise_for :admins, skip: :all
      devise_scope :admin do
        post '/admins/sign_in', to: 'api/v1/users/sessions#create'
        delete '/admins/sign_out', to: 'api/v1/users/sessions#destroy'
        post '/admins/sign_up', to: 'api/v1/users/registrations#create'
        post '/admins/password', to: 'api/v1/users/passwords#create'
        put '/admins/password', to: 'api/v1/users/passwords#update'
        get '/admins/my_user', to: 'api/v1/users/users#my_user'
      end
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'stripe_tiers/get_tiers', to: 'stripe_tier_plans#get_tiers', as: 'get_tiers' 
    end
  end
end
