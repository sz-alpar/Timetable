class TimesheetsController < ApplicationController
  before_filter :authenticate_for_admin
  
  # GET /timesheets
  # GET /timesheets.json
  def index
    @timesheets = Timesheet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @timesheets }
    end
  end

  # GET /timesheets/1
  # GET /timesheets/1.json
  def show
    @timesheet = Timesheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @timesheet }
    end
  end

  # GET /timesheets/new
  # GET /timesheets/new.json
  def new
    @timesheet = Timesheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @timesheet }
    end
  end

  # GET /timesheets/1/edit
  def edit
    @timesheet = Timesheet.find(params[:id])
  end

  # POST /timesheets
  # POST /timesheets.json
  def create
    @timesheet = Timesheet.new(params[:timesheet])

    respond_to do |format|
      if @timesheet.save
        format.html { redirect_to @timesheet, notice: 'Timesheet was successfully created.' }
        format.json { render json: @timesheet, status: :created, location: @timesheet }
      else
        format.html { render action: "new" }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /timesheets/1
  # PUT /timesheets/1.json
  def update
    @timesheet = Timesheet.find(params[:id])

    respond_to do |format|
      if @timesheet.update_attributes(params[:timesheet])
        format.html { redirect_to @timesheet, notice: 'Timesheet was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timesheets/1
  # DELETE /timesheets/1.json
  def destroy
    @timesheet = Timesheet.find(params[:id])
    @timesheet.destroy

    respond_to do |format|
      format.html { redirect_to timesheets_url }
      format.json { head :ok }
    end
  end
end
