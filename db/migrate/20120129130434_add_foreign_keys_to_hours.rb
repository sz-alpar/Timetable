class AddForeignKeysToHours < ActiveRecord::Migration
  def change
    add_column :hours, :teaches_id, :integer
    add_column :hours, :course_type_id, :integer
  end
end
