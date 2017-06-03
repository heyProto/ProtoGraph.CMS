Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' } do
      #get 'sign_in', to: 'devise/sessions#new'
      get 'sign_out', to: 'devise/sessions#destroy'
  end

  get "/auth/:provider", to: lambda{ |env| [404, {}, ["Not Found"]] }, as: :oauth
  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'

  resources :accounts do
    resources :permissions
    resources :permission_invites
    get '/authentications', to: 'authentications#index', as: 'authentication'
  end

  root 'static_pages#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
