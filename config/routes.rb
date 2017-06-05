Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' } do
      get 'sign_out', to: 'devise/sessions#destroy'
  end

  get "/auth/:provider", to: lambda{ |env| [404, {}, ["Not Found"]] }, as: :oauth
  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'

  resources :accounts do
    resources :permissions do
      get "change_role", on: :member
    end
    resources :permission_invites
    resources :authentications
    resources :services_attachables, only: [:destroy]
    resources :template_streams do
        get 'flip_public_private', 'move_to_next_status', on: :member
        resources :template_stream_cards
    end
    resources :template_data do
      get 'flip_public_private', 'move_to_next_status', on: :member
      resources :template_cards, only: [:new]
    end
    resources :template_cards do
      get 'flip_public_private', 'move_to_next_status', on: :member
    end
  end

  resources :datacast_accounts
  resources :datacasts

  root 'static_pages#index'

        # resources :thrreads do
        #   resources :thrread_files, only: [:update]
        # end
        # resources :cards do
        #   resources :card_files, only: [:update]
        # end
        # resources :assets do
        #   resources :asset_files, only: [:update]
        # end

end
