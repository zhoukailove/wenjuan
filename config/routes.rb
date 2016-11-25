Rails.application.routes.draw do
  root 'static_pages#home'


  get 'sessions/new'

  post '/get_answer_record', to: 'answer_records#get_answer_record' ,as:'get_answer_record'
  get '/answer_show', to: 'answer_records#answer_show' ,as:'answer_show'
  get '/feedback_crawling', to: 'answer_records#feedback_crawling' ,as:'feedback_crawling'
  get '/record_detail/:answer_id', to: 'answer_records#record_detail' ,as:'record_detail'
  get '/user_table/:answer_id', to: 'answer_records#user_table' ,as:'user_table'
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
