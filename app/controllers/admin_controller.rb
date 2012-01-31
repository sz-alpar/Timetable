class AdminController < ApplicationController
  before_filter :authenticate_for_admin
  
  def index
  end
  
  def new_teacher
    session[:nr_of_courses] = 2
    @nr_of_courses = session[:nr_of_courses]
    @course_types = CourseType.all
  end
  
  def save_teacher
    unless params[:add_course].nil?
      session[:nr_of_courses] += 1
      @nr_of_courses = session[:nr_of_courses]
      @course_types = CourseType.all
      
      flash.now[:params] = params
      
      render "new_teacher"
    else
      session[:nr_of_courses] = nil
      #FIXME: save the teacher and the courses
    end
  end

end
