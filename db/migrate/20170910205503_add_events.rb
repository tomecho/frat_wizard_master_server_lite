class AddEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|


      t.integer :point_reward

      t.string :name

      t.text :description

      t.datetime :start_time
      t.datetime :end_time

      t.references :creator_id, references: :user
      t.references :address
      t.references :org

      t.timestamps null: false
    end
  end
end
