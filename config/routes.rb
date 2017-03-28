Rails.application.routes.draw do
  namespace :score do
    root 'static_pages#home'
    get 'active_is_over', to:'static_pages#active_is_over' ,as: :active_is_over
    resources :control_centers # 用于评分的控制中心
    resources :users  do
      #  存储用户信息
      collection do
        get 'edit_all'
        post 'get_user_state' #得到用户是否进行的状态
        post 'get_pingfeng_is_begin' #得到评分状态
        post 'update_all'
      end
      member do
        get 'select_fen' #用户评分页面
      end
    end
    resources :records  do
      # 存储评分记录
      collection do
        get 'show_message'
        get 'info_fen' #初始化项目
        get 'info_production' #初始化项目
        post 'update_command_time' #更改评分状态（开始、结束）
        post 'update_user_record' #记录用户评分记录
      end
    end
    resources :controls  do
      member do
        get 'show_message'
      end
      # 评分控制开关记录
    end
  end
  # root 'static_pages#home'
  #
  #
  # get 'sessions/new'
  #
  # post '/get_answer_records', to: 'answer_records#get_answer_records' ,as:'get_answer_records'
  # post '/get_answer_record', to: 'answer_records#get_answer_record' ,as:'get_answer_record'
  # get '/answer_show', to: 'answer_records#answer_show' ,as:'answer_show'
  # get '/feedback_crawling', to: 'answer_records#feedback_crawling' ,as:'feedback_crawling'
  # get '/record_details/:pid', to: 'answer_records#record_details' ,as:'record_details'
  # get '/record_detail/:answer_id', to: 'answer_records#record_detail' ,as:'record_detail'
  # # get '/user_table/:answer_id', to: 'answer_records#user_table' ,as:'user_table'
  # get '/user_table', to: 'answer_records#user_table' ,as:'user_table'
  # get '/feedback_record/:id', to: 'answer_records#feedback_record' ,as:'feedback_record'
  # get '/two_index' , to: 'answer_commands#two_index'
  # post '/info_all' , to: 'answer_commands#info_all'
  # post '/update_command_time' , to: 'answer_commands#update_command_time'
  # post '/update_command_times' , to: 'answer_commands#update_command_times'
  # post '/post_answer' , to: 'static_pages#post_answer'
  # post '/get_time' , to: 'static_pages#get_time'
  # resources :answer_commands
  # resources :answer_records
  #
  # get '/signup', to: 'users#new'
  # post '/signup', to: 'users#create'
  #
  # get '/login', to: 'sessions#new'
  # post '/login', to:'sessions#create'
  # delete '/logout', to: 'sessions#destroy'
  #
  # resources :users
  #
  # get '/active_end', to:'static_pages#help'
  #
  # # get 'static_pages/home'
  #
  #
  #
  # resources :microposts

  # root 'static_pages#home'
  # root 'application#strong'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
