Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope :api, defaults: { format: :json } do
    scope :v1 do
      devise_for :customers, skip: :all
      devise_scope :customer do
        post '/customers/sign_in', to: 'api/v1/users/sessions#create'
        delete '/customers/sign_out', to: 'api/v1/users/sessions#destroy'
        post '/users/sign_up', to: 'api/v1/users/registrations#create'
        post '/customers/password', to: 'api/v1/users/passwords#create'
        put '/customers/password', to: 'api/v1/users/passwords#update'
        get '/users/my_user', to: 'api/v1/users/users#my_user'
      end

      devise_for :admins, skip: :all
      devise_scope :admin do
        post '/admins/sign_in', to: 'api/v1/users/sessions#create'
        delete '/admins/sign_out', to: 'api/v1/users/sessions#destroy'
        post '/admins/sign_up', to: 'api/v1/users/registrations#create'
        post '/admins/password', to: 'api/v1/users/passwords#create'
        put '/admins/password', to: 'api/v1/users/passwords#update'
        get '/users/my_user', to: 'api/v1/users/users#my_user'
      end
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'stripe_tiers/get_tiers', to: 'stripe_tier_plans#get_tiers', as: 'get_tiers'
      get 'stripe_tiers/get_active_subscriptions', to: 'stripe_tier_plans#get_active_subscriptions', as: 'get_active_subscriptions'
      get 'stripe_tiers/update_subscription', to: 'stripe_tier_plans#update_subscription', as: 'update_subscription'
      get 'stripe_tiers/cancel_subscription', to: 'stripe_tier_plans#cancel_subscription', as: 'cancel_subscription'
      get 'postal_codes/validate', to: 'postal_codes#validate_postal_code', as: 'validate_postal_code'
      get 'stats', to: 'orders#stats', as: 'stats'
      post 'orders/validate_order', to: 'orders#validate_order', as: 'validate_order'
      resources :products, only: [:index,:create,:show, :update]
      resources :orders, only: [:index,:create,:show, :update]
      resources :categories, only: [:index,:create,:show, :update]
      resources :postal_codes, only: [:index, :create, :show, :update]
      resources :suggestions, only: [:index,:create,:show]
      get 'notifications/has_unseen_notifications', to: 'notifications#has_unseen_notifications', as: 'has_unseen_notifications'
      resources :notifications, only: [:index,:show, :update, :has_unseen_notifications]
    end
  end
end
