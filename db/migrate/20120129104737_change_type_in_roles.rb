class ChangeTypeInRoles < ActiveRecord::Migration
  def change
    rename_column :roles, :type, :permission
  end
end