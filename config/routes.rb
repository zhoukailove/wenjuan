Rails.application.routes.draw do
  resources :answer_commands
  resources :answer_records

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users

  get 'static_pages/home'

  get 'static_pages/help'

  resources :microposts

  root 'static_pages#home'
  # root 'application#strong'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
