class AddTimesheetForeignKeyToHour < ActiveRecord::Migration
  def change
    add_column :hours, :timesheet_id, :integer
  end
end
