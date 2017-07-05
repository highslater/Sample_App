Rails.application.routes.draw do

  root                to: 'static_pages#home'

  get     '/help',    to: 'static_pages#help'
  get     '/about',   to: 'static_pages#about'
  get     '/contact', to: 'static_pages#contact'

  get     '/signup',  to: 'users#new'
  post    '/signup',  to: 'users#create'

  resources :users,               only: [ :index, :edit, :show, :update, :destroy ] do
    member do
      get :following, :followers
    end
  end

  get     'login',    to: 'sessions#new'
  post    'login',    to: 'sessions#create'
  delete  'logout',   to: 'sessions#destroy'

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]

end

=begin

$ rails routes
                 Prefix Verb   URI Pattern                             Controller#Action

                   root GET    /                                       static_pages#home
                   help GET    /help(.:format)                         static_pages#help
                  about GET    /about(.:format)                        static_pages#about
                contact GET    /contact(.:format)                      static_pages#contact

                 signup GET    /signup(.:format)                       users#new
                        POST   /signup(.:format)                       users#create

         following_user GET    /users/:id/following(.:format)          users#following
       followerers_user GET    /users/:id/followerers(.:format)        users#followerers
       
                  users GET    /users(.:format)                        users#index
              edit_user GET    /users/:id/edit(.:format)               users#edit
                   user GET    /users/:id(.:format)                    users#show
                        PATCH  /users/:id(.:format)                    users#update
                        PUT    /users/:id(.:format)                    users#update
                        DELETE /users/:id(.:format)                    users#destroy

                  login GET    /login(.:format)                        sessions#new
                        POST   /login(.:format)                        sessions#create
                 logout DELETE /logout(.:format)                       sessions#destroy

edit_account_activation GET    /account_activations/:id/edit(.:format) account_activations#edit

        password_resets POST   /password_resets(.:format)              password_resets#create
     new_password_reset GET    /password_resets/new(.:format)          password_resets#new
    edit_password_reset GET    /password_resets/:id/edit(.:format)     password_resets#edit
         password_reset PATCH  /password_resets/:id(.:format)          password_resets#update
                        PUT    /password_resets/:id(.:format)          password_resets#update

             microposts POST   /microposts(.:format)                   microposts#create
              micropost DELETE /microposts/:id(.:format)               microposts#destroy




=end
