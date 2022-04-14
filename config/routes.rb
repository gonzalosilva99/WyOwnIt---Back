Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope :api, defaults: { format: :json } do
    scope :v1 do
      devise_for :users, skip: :all

      devise_scope :user do
        post '/users/sign_in', to: 'api/v1/users/sessions#create'
        delete '/users/sign_out', to: 'api/v1/users/sessions#destroy'
        post '/users/sign_up', to: 'api/v1/users/registrations#create'
        post '/users/password', to: 'api/v1/users/passwords#create'
        put '/users/password', to: 'api/v1/users/passwords#update'
      end
    end
  end
end
