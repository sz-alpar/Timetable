class LoginController < ApplicationController
  before_filter :redirect_if_already_logged_in, :except => :destroy
  
  def index
  end

  def verify
    if params[:username] == ""
      usernameError = "Username field empty."
    end

    if params[:password] == ""
      passwordError = "Password field empty."
    end

    unless usernameError.nil? && passwordError.nil?
      flash.now[:passwordError] = passwordError
      flash.now[:usernameError] = usernameError
      flash.now[:params] = params
      render "index"
      return
    end

    user = User.where(:name => params[:username], :password => params[:password]).first

    unless user.nil?
      session[:user_id] = user.id
      
      if user.role.admin?
        redirect_to admin_path
        return
      else
        redirect_to teacher_path
        return
      end
    else
      flash.now[:params] = params
      flash.now[:error] = "Login failed."
      render "index"
    end
  end

  def destroy
    if already_logged_in?    
      reset_session
    end
    redirect_to login_path
  end

  def already_logged_in?
    unless session[:user_id].nil?
      true  
    end
  end
  
  private
  def redirect_if_already_logged_in
    if already_logged_in?
      redirect_to admin_path
    end    
  end

end
