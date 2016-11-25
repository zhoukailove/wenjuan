class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :ipad

  def admin
    if (['answer_commands', 'answer_records', 'rooms'].include? controller_name) && current_user && current_user.id != User.last.id
      redirect_to login_path
    end
  end

  def admin?
    return  current_user || current_user.id != User.last.id ? false : true
  end


  def ipad
    agent_str = request.user_agent.to_s.downcase
    logger.info agent_str
    if current_user
    if agent_str =~ /pad/ || (['answer_commands','answer_records'].include? controller_name) ||
        ((['static_pages'].include? controller_name) && (['help'].include? action_name))
      return true
    else
      redirect_to active_end_path
    end
    else
      redirect_to login_path     unless (['sessions'].include? controller_name)

    end
  end

  def mobile?
    agent_str = request.user_agent.to_s.downcase
    return false if agent_str =~ /ipad/
  end


  def hello
    render html: "hola, mundo!"
  end

  def goodbye
    render plain: 'goodbye'
  end

  def strong
    render html: '<strong>strong</strong>'
  end

  def body_raw
    render body: 'raw'
  end


  private
  # 确保是正确的用户
  def correct_user
    if params[:id] && @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    else
      redirect_to(root_url)
    end
  end

  # 确保用户已登录
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = '请登录'
      redirect_to login_url
    end
  end

end
