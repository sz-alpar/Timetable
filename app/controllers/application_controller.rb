class ApplicationController < ActionController::Base
  # A feature in Rails that protects against Cross-site Request Forgery (CSRF) attacks. 
  # This feature makes all generated forms have a hidden id field. This id field must 
  # match the stored id or the form submission is not accepted. This prevents malicious 
  # forms on other sites or forms inserted with XSS from submitting to the Rails application.
  protect_from_forgery
  
  before_filter :load_user_name
  before_filter :set_locale
 
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def default_url_options(options={})
    { :locale => I18n.locale }
  end
  
  def load_user_name
    unless session[:user_id].nil?
      user = User.where(:id => session[:user_id]).first
      @user_name = user.name
      @admin = user.role.admin?
    end
  end
  
  def authenticate
    if session[:user_id].nil?
      redirect_to login_path
    else
      true
    end
  end
  
  def authenticate_for_admin
    if session[:user_id].nil?
      redirect_to login_path
    else
      unless @admin
        redirect_to teacher_path
      end
    end
  end
end
