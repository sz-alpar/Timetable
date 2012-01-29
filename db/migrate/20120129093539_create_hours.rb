class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.timestamp :hours

      t.timestamps
    end
  end
end
