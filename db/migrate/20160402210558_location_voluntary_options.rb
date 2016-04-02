class LocationVoluntaryOptions < ActiveRecord::Migration
  def change
    add_column :users, :location_enabled, :boolean
  end
end
