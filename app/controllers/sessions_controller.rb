class SessionsController < ApplicationController
  def new
      redirect_to root_path if current_user
  end

  def create
    @user = User.find_by(login_name: params[:session][:login_name].downcase)
    if @user && @user[:password]==(params[:session][:password])
      # 登入用户,然后重定向到用户的资料页面
      # flash[:success] = "Welcome to the Sample App!"
      log_in @user
      remember @user
      # redirect_to @user
      redirect_to root_path
    else
      flash[:danger] = 'Invalid email/password combination' # 不完全正确
      render 'new'
    end
  end

  def destroy
    log_out  if logged_in?
    redirect_to root_url
  end
end
