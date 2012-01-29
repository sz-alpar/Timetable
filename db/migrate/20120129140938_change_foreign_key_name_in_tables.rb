class ChangeForeignKeyNameInTables < ActiveRecord::Migration
  def change
    rename_column :hours, :teaches_id, :teach_id
    
    rename_column :wishes, :teaches_id, :teach_id
  end
end
