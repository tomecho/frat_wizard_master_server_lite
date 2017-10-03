class AddAttendance < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.references :event_id
      t.references :user_id
      t.timestamps
      t.integer :points_earned
    end
  end
end
