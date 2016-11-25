class Locations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :long
      t.string :lat
      t.string :description
    end
  end
end
