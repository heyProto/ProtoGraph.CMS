Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' } do
      get 'sign_out', to: 'devise/sessions#destroy'
  end

  get "/auth/:provider", to: lambda{ |env| [404, {}, ["Not Found"]] }, as: :oauth
  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'


  scope :api do
    scope :v1 do
      resources :accounts, only: [] do
        resources :template_cards, only: [:index, :show], controller: "api/v1/template_cards"
      end
    end
  end

  resources :accounts do
    resources :permissions do
      get "change_role", on: :member
    end
    resources :permission_invites
    resources :authentications
    resources :services_attachables, only: [:destroy] do
      put "upload_file", on: :member
      delete "file", on: :member
    end

    resources :template_data do
      get 'flip_public_private', 'move_to_next_status', on: :member
      get "/new/:version_genre/version", to: "template_data#new", on: :member, as: :create_version
      resources :template_cards, only: [:new] do
        get "/new/:version_genre/version", to: "template_cards#new", on: :member, as: :create_version
      end
    end

    resources :template_cards do
      get 'flip_public_private', 'move_to_next_status', on: :member
    end

    resources :datacasts
  end

  # resources :datacast_accounts

  root 'static_pages#index'

end
