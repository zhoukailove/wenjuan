Rails.application.routes.draw do
  root 'static_pages#home'


  get 'sessions/new'

  get '/answer_show', to: 'answer_records#answer_show' ,as:'answer_show'
  get '/feedback_crawling', to: 'answer_records#feedback_crawling' ,as:'feedback_crawling'
  get '/feedback_record/:id', to: 'answer_records#feedback_record' ,as:'feedback_record'
  post '/info_all' , to: 'answer_commands#info_all'
  post '/update_command_time' , to: 'answer_commands#update_command_time'
  post '/post_answer' , to: 'static_pages#post_answer'
  post '/get_time' , to: 'static_pages#get_time'
  resources :answer_commands
  resources :answer_records

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users

  get '/active_end', to:'static_pages#help'

  # get 'static_pages/home'



  resources :microposts

  # root 'static_pages#home'
  # root 'application#strong'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
