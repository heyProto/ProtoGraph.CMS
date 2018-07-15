Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {registrations: 'user/registrations'} do
    get 'sign_out', to: 'devise/sessions#destroy'
  end

  resources :users do
      resources :user_emails, only: [:index, :create, :destroy]
      get '/user_emails/confirmation', to: "user_emails#confirmation", as: "email_confirmation"
  end

  namespace :api do
    namespace :v1 do
      resources :sites, only: [] do
        resources :folders do
          resources :pages, only: [:create, :update]
          resources :streams, only: [:create, :update]
          resources :template_cards, only: [:index, :show] do
            get "validate", on: :member
          end
          resources :datacasts, only: [:create, :update]
          resources :streams, only: [:create, :update]
          post "/streams/:id/publish", to: "streams#publish", as: :publish_stream
        end
      end

      # resources :folders, only: [] do
      #   resources :template_cards, only: [:index, :show] do
      #     get "validate", on: :member
      #   end
      #   resources :datacasts, only: [:create, :update]
      #   resources :streams, only: [:create, :update]
      #   post "/streams/:id/publish", to: "streams#publish", as: :publish_stream
      # end
      post "smartcrop", to: "utilities#smartcrop"
      get '/iframely', to: "utilities#iframely"
      get '/oembed', to: "utilities#oembed"
      resources :view_casts, only: [:show]
      resources :template_data, only: [:create]
    end
  end
    
  get ":site_id/apps", to: "template_apps#index", as: :apps_site
  
  resources :sites do
    #app store --- 
    resources :template_apps, only: [:edit, :update]
    resources :site_template_apps, only: [:index, :destroy, :install] do
      post "invite", on: :member
      get "accept", on: :member
    end
    resources :template_data, only: [:show] do
      resources :template_fields do
        get "move_up", on: :member
        get "move_down", on: :member
      end
    end
    #app store --- 
    
    resources :permissions do
      get "change_owner_role", on: :member
      put "change_role", on: :member
    end
    resources :permission_invites
    get "remove_favicon", "remove_logo", "integrations", on: :member
    resources :ref_categories do
      get 'landing_card', on: :member
      resources :feeds do
        post "force_fetch_feeds", on: :member
      end
      resources :feed_links do
        post "create_view_cast", on: :member
      end
      resources :site_vertical_navigations do
        put "move_up", "move_down", on: :member
      end
      put '/disable', to: "ref_categories#disable", on: :member
    end
    get "/sections", to: "ref_categories#sections", on: :member
    get "/intersections", to: "ref_categories#intersections", on: :member
    get "/sub_intersections", to: "ref_categories#sub_intersections", on: :member

    resources :folders do
      resources :stories, only: [:index]

      resources :view_casts
      resources :uploads, only: [:new, :create, :index]
    end
    resources :pages do
      put "remove_cover_image", on: :member
      get "distribute", on: :member
      get "ads", on: :member
      resources :ad_integrations, only: [:create, :destroy]
    end
    resources :stories, only: [:index] do
      get "edit/write", to: "stories#edit_write", on: :member
      get "edit/assemble", to: "stories#edit_assemble", on: :member
      get "edit/distribute", to: "stories#edit_distribute", on: :member
      get "edit/ads", to: "stories#edit_ads", on: :member
      post "import", to: "stories#import_story", on: :collection
    end
    resources :streams do
      post :publish, on: :member
      resources :stream_entities, only: [:create, :destroy] do
        put "move_up", "move_down", on: :member
      end
    end
    resources :page_streams, only: [:update]
    resources :images, only: [:index, :create, :show]
    resources :image_variations, only: [:create, :show] do
      post :download, on: :member
    end
  end
  
  root 'static_pages#index'
end
