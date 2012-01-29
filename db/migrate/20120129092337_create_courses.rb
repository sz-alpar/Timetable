class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :code
      t.string :title
      t.string :description
      t.integer :semester

      t.timestamps
    end
  end
end
