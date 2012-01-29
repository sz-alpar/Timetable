class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.boolean :to_be_held
      t.timestamp :when
      t.boolean :important

      t.timestamps
    end
  end
end
