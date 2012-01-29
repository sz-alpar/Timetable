class AddForeignKeysToTables < ActiveRecord::Migration
  def change
     add_column :teaches, :user_id, :integer
     add_column :teaches, :course_id, :integer
     
     add_column :timesheets, :hour_id, :integer
     
     add_column :users, :role_id, :integer
     
     add_column :wishes, :teaches_id, :integer
     add_column :wishes, :hour_id, :integer
  end
end
