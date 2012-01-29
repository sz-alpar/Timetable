class ChangeTypeInCourseTypes < ActiveRecord::Migration
  def change
    rename_column :course_types, :type, :name
  end
end
