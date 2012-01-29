class LoginController < ApplicationController
  def index
    
  end

  def verify
    if alreadyLoggedIn?
      flash.now[:notice] = "Already logged in."
      render "index"
      return
    end
    
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
        flash.now[:notice] = "Admin user logged in."
        render "index"
      else
        flash.now[:notice] = "Normal user logged in."
        render "index"
      end
    else
      flash.now[:params] = params
      flash.now[:error] = "Login failed."
      render "index"
    end
  end

  def destroy
    reset_session
  end

  def alreadyLoggedIn?
    !session[:user_id].nil?
  end

end
