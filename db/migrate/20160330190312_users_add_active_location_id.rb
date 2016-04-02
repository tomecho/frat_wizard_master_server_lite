class UsersAddActiveLocationId < ActiveRecord::Migration
  def change
    add_column :users, :most_recent_location_id, :integer
  end
end
