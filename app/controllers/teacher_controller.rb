class TeacherController < ApplicationController
  before_filter :authenticate_for_admin, :only => [:new_teacher, :save_teacher, :edit_teacher]
  before_filter :authenticate
  
  def index
    redirect_to teacher_timesheet_path(session[:user_id])
  end

  def new_teacher
    session[:nr_of_courses] = DEFAULT_NR_OF_COURSES
    @nr_of_courses = session[:nr_of_courses]
    @course_types = CourseType.all
  end

  def save_teacher
    @nr_of_courses = session[:nr_of_courses]
    @course_types = CourseType.all

    unless params[:add_course].nil?
      @nr_of_courses += 1
      session[:nr_of_courses] = @nr_of_courses

      flash.now[:params] = params

      render "new_teacher"
    else
      session[:edited_user_id] = nil
      @edited_user_id = session[:edited_user_id]

      if save_teacher_to_db "new_teacher"
        session[:nr_of_courses] = nil
   
        redirect_to admin_path
      end
    end
  end
  
  def edit_teacher
    @teachers = User.where( :role_id => Role.where( :permission => "teacher").first.id )
    
    @nr_of_courses = session[:nr_of_courses]
    @course_types = CourseType.all
    @disabled = nil
    
    unless params[:id].nil?
      session[:edited_user_id] = params[:id]
      @edited_user_id = session[:edited_user_id]
    end
    
    if params[:add_course] != nil
      @nr_of_courses += 1
      session[:nr_of_courses] = @nr_of_courses

      @course_ids = session[:course_ids]
      @edited_user_id = session[:edited_user_id]

      flash.now[:params] = params

      render "edit_teacher"
    elsif params.has_value? t(:remove_course)
      remove_course_id = params.key t(:remove_course)

      @nr_of_courses -= 1 unless @nr_of_courses == 0
      session[:nr_of_courses] = @nr_of_courses
      
      @edited_user_id = session[:edited_user_id]
      
      unless session[:course_ids].nil?
        session[:course_ids] = session[:course_ids].find_all do |course_id|
          course_id.to_i != remove_course_id.to_i
        end
        
        @course_ids = session[:course_ids]
        
        teacher = User.where(:id => session[:edited_user_id]).first
        
        i = 0
        j = 0
        teacher.teaches.all.each do |teach|
          found = false
          session[:course_ids].each do |course_id|
            if course_id.to_i == teach.course.id.to_i
              found = true
              break
            end
          end
          
          unless found
            params.delete("course_title" + i.to_s)
            params.delete("course_description" + i.to_s)
            params.delete("course_semester" + i.to_s)
            params.delete("course_code" + i.to_s)
            
            hours = teach.hours.all
            hours.each do |hour|
              params.delete("course" + i.to_s + "_type_id_" + hour.course_type.id.to_s)
            end
          else
            params["course_title" + j.to_s] = teach.course.title
            params["course_description" + j.to_s] = teach.course.description
            params["course_semester" + j.to_s] = teach.course.semester
            params["course_code" + j.to_s] = teach.course.code
            
            hours = teach.hours.all
            hours.each do |hour|
              params["course" + j.to_s + "_type_id_" + hour.course_type.id.to_s] = hour.hours.to_i / 3600
            end
            
            j += 1
          end
          i += 1
        end
      end

      flash.now[:params] = params

      render "edit_teacher"
    elsif params[:update_teacher] != nil
      if save_teacher_to_db "edit_teacher"
        edit_user_id = session[:edited_user_id]
        session[:nr_of_courses] = nil
        session[:edited_user_id] = nil
        @edited_user_id = session[:edited_user_id]
        session[:course_ids] = nil
        
        flash.now[:error] = "Saved"
  
        redirect_to admin_edit_teacher_path(edit_user_id)
      end
    elsif params[:id].nil?
      session[:nr_of_courses] = DEFAULT_NR_OF_COURSES
      @nr_of_courses = session[:nr_of_courses]
      @disabled = "disabled"
      @course_ids = []
    else
      session[:course_ids] = nil
      
      teacher = User.where(:id => params[:id]).first
      
      if teacher.nil?
        @disabled = "disabled"
        return
      end 
      
      params[:username] = teacher.name
      params[:password] = teacher.password
      
      teaches = teacher.teaches.all
      session[:course_ids] = teacher.course_ids
      @course_ids = session[:course_ids]
      
      @nr_of_courses = teaches.length
      session[:nr_of_courses] = @nr_of_courses
      
      teaches.each_with_index do |teach, i| 
        params["course_title" + i.to_s] = teach.course.title
        params["course_description" + i.to_s] = teach.course.description
        params["course_semester" + i.to_s] = teach.course.semester
        params["course_code" + i.to_s] = teach.course.code
        
        hours = teach.hours.all
        hours.each do |hour|
          params["course" + i.to_s + "_type_id_" + hour.course_type.id.to_s] = hour.hours.to_i / 3600
        end
      end
      
      flash.now[:params] = params
      
      render "edit_teacher"
    end
  end
  
  def delete_teacher
    unless params[:id].nil?
      user = User.where(:id => params[:id]).first
      unless user.nil?
        user.destroy
      end
    end
    
    redirect_to admin_show_edit_teacher_path
  end

  private
  def save_teacher_to_db(path_to_display_error)
    if params[:username] == ""
      usernameError = "Username field empty."
    end

    if params[:password] == ""
      passwordError = "Password field empty."
    end

    courses = []
    course_types = []

    courseError = {}
    courseTypeError = {}
    session[:nr_of_courses].times do |i|
      course_fields = ["course_title", "course_code", "course_description", "course_semester"]

      course_params = {}
      course_fields.each do |course_field|
        course_tag_id = course_field + i.to_s
        if params[course_tag_id] == ""
          courseError[course_tag_id] = "Field empty."
        else
          course_params[course_field] = params[course_tag_id]
        end
      end
      
      courses << course_params

      course_type_value = []

      @course_types.each do |course_type|
        type_tag_id = "course" + i.to_s + "_type_id_" + course_type.id.to_s
        if params[type_tag_id] == ""
          courseTypeError[type_tag_id] = "Course Type field empty."
        else
          course_type_value << params[type_tag_id]
        end
      end

      course_types << course_type_value
    end

    unless usernameError.nil? && passwordError.nil? && courseError.empty? && courseTypeError.empty?
      flash.now[:passwordError] = passwordError
      flash.now[:usernameError] = usernameError
      flash.now[:courseError] = courseError
      flash.now[:courseTypeError] = courseTypeError
      flash.now[:params] = params
      render path_to_display_error
    return
    end
    
    if session[:edited_user_id] != nil
      user = User.where(:id => session[:edited_user_id]).first
    end
    
    user_courses = []
    if user.nil?
      user = User.new :name => params[:username], :password => params[:password]
      user.role = Role.where(:permission => "teacher").first
    else
      user.name = params[:username]
      user.password = params[:password]
      
      user_courses = user.courses.all
      
      unless session[:course_ids].nil?
        user_courses = user_courses.find_all do |course|
          found = false
          session[:course_ids].each do |needed_course_id|
            if needed_course_id.to_i == course.id.to_i
              found = true
              break
            end
          end
          unless found
            course.destroy
          end
          found
        end
      end
      
    end
    
    user.save
    
    course_models = []
    course_hours = []
    
    courses.each_with_index do |course_params, i|
      title = ""
      description = ""
      code = ""
      semester = ""
      
      course_params.each do |key, value|
        case key
        when "course_title"
          title = value
        when "course_code"
          code = value
        when "course_description"
          description = value
        when "course_semester"
          semester = value  
        end  
      end

      if user_courses.length < courses.length
        course = Course.where(:title => title, :code => code, :description => description, :semester => semester).first
        
        if course.nil?
          course = Course.new :title => title, :code => code, :description => description, :semester => semester
        end
      else
        course = user_courses[i]
        
        course.title = title
        course.code = code
        course.description = description
        course.semester = semester
      end
      
      course_models << course
      
      hours = []
      
      @course_types.each do |course_type|
        type_tag_id = "course" + i.to_s + "_type_id_" + course_type.id.to_s
        
        course_type_hour = params[type_tag_id]
        
        if user_courses.length < courses.length        
          hour = Hour.new :hours => Time.at(course_type_hour.to_i * 3600).gmtime
          hour.course_type = course_type
        else
          hour = user.teaches.all[i].hours.where(:course_type_id => course_type.id).first
          hour.hours = Time.at(course_type_hour.to_i * 3600).gmtime
        end
        
        hours << hour
      end
      
      course_hours << hours
    end
    
    course_models.each_with_index do |course_model, i|
      course_model.save
      
      hour_models = course_hours[i]
      
      if session[:edited_user_id] != nil &&
          user.teaches.length >= course_models.length
        teach = user.teaches.where(:user_id => session[:edited_user_id], :course_id => course_model.id).first
      else
        teach = Teach.where(:user_id => user.id, :course_id => course_model.id).first
        
        if teach.nil?
          teach = Teach.new :user_id => user.id, :course_id => course_model.id
        end
      end
      
      hour_models.each do |hour_model|
        hour_model.teach = teach
        
        hour_model.save
      end
      
      teach.save
    end
    
    return true
  end

end
