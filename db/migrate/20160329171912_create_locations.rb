class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.decimal :long
      t.decimal :lat

      t.timestamps null: false
    end
  end
end
