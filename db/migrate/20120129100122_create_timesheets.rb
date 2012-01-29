class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.timestamp :start_time
      t.integer :repeats

      t.timestamps
    end
  end
end
