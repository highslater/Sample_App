Rails.application.routes.draw do

  root                to: 'static_pages#home'

  get     '/help',    to: 'static_pages#help'
  get     '/about',   to: 'static_pages#about'
  get     '/contact', to: 'static_pages#contact'

  get     '/signup',  to: 'users#new'
  post    '/signup',  to: 'users#create'

  resources :users,   only: [ :index, :edit, :show, :update, :destroy ]

  get     'login',    to: 'sessions#new'
  post    'login',    to: 'sessions#create'
  delete  'logout',   to: 'sessions#destroy'

  resources :account_activations, only: [:edit]

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

=end
