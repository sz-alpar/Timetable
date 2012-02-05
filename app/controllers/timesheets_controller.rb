class TimesheetsController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate_for_admin, :only => [:save, :edit]

  def index
    load_data
    
    @timesheets = Timesheet.order('start_time ASC').all

    @time_table_cells = []
    @timesheets.each_with_index do |timesheet, i|
      hour_id = params["cell_" + i.to_s]
      hour = Hour.where(:id => hour_id).first
      unless hour.nil?
        teach = hour.teach
        unless teach.nil?
          unless params[:id].nil?
            if teach.user_id.to_i == params[:id].to_i
              @time_table_cells[i] = hour.course_type.name.to_s + " - " + teach.course.title
            else
              @time_table_cells[i] = ""
            end
          else
            @time_table_cells[i] = hour.course_type.name.to_s + " - " + teach.course.title
          end
        else
          @time_table_cells[i] = ""
        end
      else
        @time_table_cells[i] = ""
      end
      
    end
  end
  
  def edit
    load_data  
  end

  def save
    unless params[:modified_cell_id].nil?
      hour_id = params[params[:modified_cell_id]]

      if hour_id.to_s != " "
        hour = Hour.where(:id => hour_id).first
        
        unless hour.nil?
          cell_id = params[:modified_cell_id].match(/\d*$/)[0].to_i
          
          start_time = (8 + (cell_id % 6 * 2) + 24 * (cell_id / 6)) * 3600
          timesheet = Timesheet.where(:start_time => Time.at(start_time).gmtime).first
          
          unless timesheet.nil?
            hour.timesheet = timesheet
            timesheet.hour = hour
            hour.save
            timesheet.save
          end
        end
      else
        cell_id = params[:modified_cell_id].match(/\d*$/)[0].to_i
        start_time = (8 + (cell_id % 6 * 2) + 24 * (cell_id / 6)) * 3600
        timesheet = Timesheet.where(:start_time => Time.at(start_time).gmtime).first

        unless timesheet.nil?
          hour = timesheet.hour
          unless hour.nil?
            hour.timesheet = nil
            hour.save
          end
          timesheet.hour = nil
          timesheet.save
        end
      end
    end
    
    load_data
    
    respond_with do |format|
      format.html do 
        if request.xhr?
           render :partial => "timesheets/edit_timetable", :locals => {:all_grouped_options => @all_grouped_options, :params => params}
        else
          render "index"
        end
      end
    end
  end

  private
  def load_data
    @timesheets = Timesheet.order('start_time ASC').all
    
    @all_grouped_options = []
    
    @timesheets.each_with_index do |timesheet, i|
      params["cell_" + i.to_s] = " "
    end
    
    hours_assigned = []
    unassigned_grouped_options = {"" => [" "]}
    @teaches = Teach.all
    @teaches.each do |teach|
      unless teach.course.nil?
        teach.hours.each do |hour|
          if hour.hours != Time.at(0).gmtime
            if unassigned_grouped_options[teach.course.title].nil?
              unassigned_grouped_options[teach.course.title] = []
            end
            
            unless hour.timesheet.nil?
              hours_assigned << hour
              
              time = Time.at(hour.timesheet.start_time).gmtime
              cell_index = (time.day - 1) * 6 + (time.hour - 8) / 2
              cell_id = "cell_" + cell_index.to_s
              params[cell_id] = hour.id
            end
            
            unless hours_assigned.include? hour
              unassigned_grouped_options[teach.course.title] << [hour.course_type.name.to_s + " - " + teach.course.title, hour.id]
            end
          end
        end
      end
    end
    
    @timesheets.each_with_index do |timesheet, i|
      @all_grouped_options[i] = Marshal.load(Marshal.dump(unassigned_grouped_options))
      if params["cell_" + i.to_s].to_s != " "
        hour_id = params["cell_" + i.to_s]
        hour = Hour.where(:id => hour_id).first
        unless hour.nil?
          teach = hour.teach
          @all_grouped_options[i][teach.course.title] << [hour.course_type.name.to_s + " - " + teach.course.title, hour.id]
        end
      end
    end
  end

end
