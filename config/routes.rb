Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :activities
  devise_for :users, controllers: {
               registrations: 'user/registrations',
               sessions: 'user/sessions',
               omniauth_callbacks: "user/omniauth_callbacks"
             } do
    get 'sign_out', to: 'devise/sessions#destroy'
  end

  resources :users do
      resources :user_emails, only: [:index, :create, :destroy]
      get '/user_emails/confirmation', to: "user_emails#confirmation", as: "email_confirmation"
  end

  namespace :admin do
    get "online_users", to: "online_users#index", as: :online_users
  end

  resources :ref_link_sources do
    post "publish", on: :collection
  end

  get "/auth/:provider", to: lambda{ |env| [404, {}, ["Not Found"]] }, as: :oauth
  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'
  get "/planned-homepage", to: "static_pages#index2"

  namespace :api do
    namespace :v1 do
      resources :accounts, only: [] do
        resources :sites, only: [] do
          resources :folders, only: [] do
            resources :pages, only: [:create, :update]
            resources :streams, only: [:create, :update]
          end
        end

        resources :folders, only: [] do
          resources :template_cards, only: [:index, :show] do
            get "validate", on: :member
          end
          resources :datacasts, only: [:create, :update]
          resources :streams, only: [:create, :update]
          post "/streams/:id/publish", to: "streams#publish", as: :publish_stream
        end
      end
      get '/iframely', to: "utilities#iframely"
      get '/oembed', to: "utilities#oembed"
      resources :view_casts, only: [:show]
      resources :template_data, only: [:create]
    end
  end

  resources :accounts do
    resources :permissions do
      get "change_owner_role", on: :member
      put "change_role", on: :member
    end
    resources :permission_invites
    resources :admins, only: [:index] do
      get "account_owners", on: :collection
    end
    resources :sites do
      resources :admins, only: [:index] do
        get "access_team", "access_security", on: :collection
        get 'editorial/folders', to: "admins#editorial_folders", on: :collection
        get 'site/setup', to: "admins#site_setup", on: :collection
        get 'site/theming', to: "admins#site_theming", on: :collection
        get 'site/integrations', to: "admins#site_integrations", on: :collection
      end
      resources :permissions do
        put "change_role", on: :member
      end
      resources :permission_invites
      resources :ref_categories do
        resources :site_vertical_navigations do
          put "move_up", "move_down", on: :member
        end
        put '/disable', to: "ref_categories#disable", on: :member
      end
      get "/verticals", to: "ref_categories#verticals", on: :member
      get "/intersection", to: "ref_categories#intersection", on: :member
      get "/sub_intersection", to: "ref_categories#sub_intersection", on: :member

      resources :folders do
        resources :view_casts
        resources :uploads, only: [:new, :create, :index]
      end
      resources :pages do
        get "manager", on: :collection
        put "remove_cover_image", on: :member
      end
      resources :stories, only: [:index] do
        get "edit/plan", to: "stories#edit_plan", on: :member
        get "edit/write", to: "stories#edit_write", on: :member
        get "edit/assemble", to: "stories#edit_assemble", on: :member
        get "edit/distribute", to: "stories#edit_distribute", on: :member
        resources :page_todos do
          get "complete", on: :member
        end
      end
      resources :streams do
        post :publish, on: :member
        resources :stream_entities, only: [:create, :destroy] do
          put "move_up", "move_down", on: :member
        end
      end
      resources :page_streams, only: [:update]
    end
    resources :authentications

    resources :images, only: [:index, :create, :show]
    resources :audios, only: [:index, :create, :show]
    resources :image_variations, only: [:create, :show] do
      post :download, on: :member
    end
    resources :audio_variations, only: [:create, :show] do
      post :download, on: :member
    end
  end

  get '/auth/:provider/callback', to: 'authentications#create'
  root 'static_pages#index'
end
