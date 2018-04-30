Rails.application.routes.draw do

  post 'users/change_prefecture' => 'users#change_prefecture'
  post 'events/change_prefecture' => 'events#change_prefecture'

  post 'users/create_event' => 'users#create_event'

  get 'events/index'
  get '/profile/:user_id', to: 'users#profile', as: :profile
  patch 'image_upload', to: 'users#image_upload'

  root to: 'toppages#index'

  #stripe
  resources :charges

  resources :user_photos, only: [:create, :destroy] do
    collection do
      get :list
      #get :priority
    end
  end

  get '/user_photos/:id/priority', to: 'user_photos#priority', as: :user_photos_priority

  resources :event_photos, only: [:create, :destroy] do
    collection do
      get :list
    end
  end

  get 'manage-user/:id/photos' => 'users#photos', as: 'manage_user_photos'

  #get '/profile/:user_id/user_photos', to: 'users#user_photos', as: :user_photos
#  post '/profile/:user_id/user_photos', to: 'users#user_photos', as: :user_photos

  #csv作成
  get '/admin/eigo_make_csv', to: 'admin/cities#eigo_make_csv'
  get '/admin/event_make_csv', to: 'admin/works#event_make_csv'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users do
    member do
      #get 'follow'
      #get 'block'
      get 'init_profile'
      patch 'init_profile_update'
      get 'books'
    end
  end

  namespace :admin do
    resources :users
  end

  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :create]
  end

  get '/users/follow/:user_id' => 'relationships#follow', as: :users_follow
  delete '/users/unfollow/:user_id' => 'relationships#unfollow', as: :users_unfollow
  get '/users/block/:user_id' => 'relationships#block', as: :users_block
  delete '/users/unblock/:user_id' => 'relationships#unblock', as: :users_unblock

#  resources :messages, only: [:index, :show, :new, :create]

  resources :prefectures, only: [:prefectures], path: :prefs, as: :pref do
    resources :events, only:[:index]
    resources :categories, only: [:categories], path: :cats, as: :cat do
      resources :events, only:[:index]
    end
    resources :cities, only: [:cities] do
      resources :events, only:[:index]
      resources :categories, only: [:categories], path: :cats, as: :cat do
        resources :events, only:[:index]
      end
    end
  end

  resources :categories, only: [:categories], path: :cats, as: :cat do
    resources :events, only:[:index]
  end

  get 'manage-event/:id/basics' => 'events#basics', as: 'manage_event_basics'
  get 'manage-event/:id/comment' => 'events#comment', as: 'manage_event_comment'
  get 'manage-event/:id/address' => 'events#address', as: 'manage_event_address'
  get 'manage-event/:id/price' => 'events#price', as: 'manage_event_price'
  get 'manage-event/:id/photos' => 'events#photos', as: 'manage_event_photos'
  get 'manage-event/:id/option' => 'events#option', as: 'manage_event_option'
  get 'manage-event/:id/bankaccount' => 'events#bankaccount', as: 'manage_event_bankaccount'
  get 'manage-event/:id/publish' => 'events#publish', as: 'manage_event_publish'

  #stripe connect oauth path
  get '/connect/oauth' => 'stripe#oauth', as: 'stripe_oauth'
  get '/connect/confirm' => 'stripe#confirm', as: 'stripe_confirm'
  get '/connect/deauthorize' => 'stripe#deauthorize', as: 'stripe_deauthorize'

  resources :events, :param => 'event_id'
  resources :books

  post 'holidays/create' => 'holidays#create'
#  post 'holidays/create' => 'holidays#do_map'
end
