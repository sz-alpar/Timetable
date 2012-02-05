class AdminController < ApplicationController
  before_filter :authenticate_for_admin
  
  def index
    redirect_to admin_timesheet_path
  end
  
end
