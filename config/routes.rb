Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'static_pages/index'

  resources :activities
  devise_for :users, controllers: {
               registrations: 'user/registrations',
               sessions: 'user/sessions',
               passwords: "user/passwords",
               confirmations: "user/confirmations",
               omniauth_callbacks: "user/omniauth_callbacks"
             }  do
    get 'sign_out', to: 'devise/sessions#destroy'
  end

  resources :users do
      resources :user_emails, only: [:index, :create, :destroy], as: :emails
      resources :authentications, only: [:index], as: :authentications
      get '/user_emails/confirmation', to: "user_emails#confirmation", as: "email_confirmation"
  end

  namespace :admin do
    get "online_users", to: "online_users#index", as: :online_users
  end

  get "/auth/:provider", to: lambda{ |env| [404, {}, ["Not Found"]] }, as: :oauth
  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'
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
    resources :ref_codes
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

      resources :view_casts

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

  get "cards/to-timeline", to: 'static_pages#totimeline', as: :totimeline
  get "cards/to-quiz", to: 'static_pages#toquiz', as: :toquiz
  get "cards/to-explain", to: 'static_pages#toexplain', as: :toexplain
  get "prepare-articles", to: 'static_pages#preparearticle', as: :preparearticle
  get "pages/to-count", to: 'static_pages#tocounted', as: :tocounted
  get "pages/to-cover", to: 'static_pages#tocoverage', as: :tocoverage
  get "case-studies/mobbed", to: 'static_pages#mobbed', as: :mobbed
  get "case-studies/silenced", to: 'static_pages#silenced', as: :silenced

  get "features", to: 'static_pages#features', as: :features
  get '/auth/:provider/callback', to: 'authentications#create'
  root 'static_pages#index'
end
