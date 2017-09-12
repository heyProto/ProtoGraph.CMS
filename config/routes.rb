Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'static_pages/index'

  resources :activities
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' } do
      get 'sign_out', to: 'devise/sessions#destroy'
  end

  get "/auth/:provider", to: lambda{ |env| [404, {}, ["Not Found"]] }, as: :oauth
  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'

  get "/card/:id", to: "template_cards#demo", as: :demo_template_card

  get "/planned-homepage", to: "static_pages#index2"


  namespace :api do
    namespace :v1 do
      resources :accounts, only: [] do
        resources :template_cards, only: [:index, :show] do
          get "validate", on: :member
        end
        resources :folders, only: [] do
          resources :datacasts, only: [:create, :update]
        end
      end
      get '/iframely', to: "utilities#iframely"
      get '/oembed', to: "utilities#oembed"
      resources :view_casts, only: [:show]
      resources :template_data, only: [:create]
      resources :tags, only: [:index]
    end
  end

  resources :accounts do
    resources :permissions do
      get "change_role", on: :member
    end
    resources :permission_invites
    resources :authentications

    resources :folders do
      resources :template_data do
        resources :template_cards, only: [:new] do
          post "/create_version/:version_genre", to: "template_cards#create_version", on: :member, as: :create_version
        end
      end

      resources :template_cards do
        get 'flip_public_private', 'move_to_next_status', on: :member
      end

      resources :view_casts, only: [:new, :show, :edit, :update]

      resources :streams do
        post :publish, on: :member
        resources :stream_entities, only: [:create, :destroy]
      end
      resources :uploads, only: [:index, :create]
      resources :articles do
        put "remove_cover_image", on: :member
        put "remove_facebook_image", on: :member
        put "remove_twitter_image", on: :member
        put "remove_instagram_image", on: :member
      end
      resources :uploads, only: [:new, :create]
    end
    resources :images, only: [:index, :create, :show]
    resources :image_variations, only: [:create, :show] do
      post :download, on: :member
    end

  end

  get "docs", to: 'docs#index', as: :docs
  get "docs/cards", to: 'docs#cards', as: :docs_cards
  get "docs/cards/build-your-own", to: 'docs#cards_build_your_own', as: :docs_cards_build_your_own
  get "docs/cards/design-recommendation", to: 'docs#cards_design_recommendation', as: :docs_cards_design_recommendation
  get "docs/cards/styleguide/icons", to: 'docs#cards_styleguide_icons', as: :docs_cards_styleguide_icons
  get "docs/cards/publishing", to: 'docs#cards_publishing', as: :docs_cards_publishing
  get "docs/streams", to: 'docs#streams', as: :docs_streams

  get "features", to: 'static_pages#features', as: :features
  get '/auth/:provider/callback', to: 'authentications#create'
  root 'static_pages#index'
end
