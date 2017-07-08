Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' } do
      get 'sign_out', to: 'devise/sessions#destroy'
  end

  get "/auth/:provider", to: lambda{ |env| [404, {}, ["Not Found"]] }, as: :oauth
  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'


  namespace :api do
    namespace :v1 do
      resources :accounts, only: [] do
        resources :template_cards, only: [:index, :show]
        resources :datacasts, only: [:create, :update]
      end
      resources :view_casts, only: [:show]
      resources :template_data, only: [:create]
    end
  end

  resources :accounts do
    resources :permissions do
      get "change_role", on: :member
    end
    resources :permission_invites
    resources :authentications

    resources :template_data do
      resources :template_cards, only: [:new] do
        get "/new/:version_genre/version", to: "template_cards#new", on: :member, as: :create_version
      end
    end

    resources :template_cards do
      get 'flip_public_private', 'move_to_next_status', on: :member
    end

    resources :view_casts, only: [:new, :index, :show, :edit] do
      put :"recreate/:mode", to: "view_casts#recreate", on: :member, as: :recreate
    end

  end

  get "features", to: 'static_pages#features', as: :features
  get '/auth/:provider/callback', to: 'authentications#create'
  root 'static_pages#index'

end
