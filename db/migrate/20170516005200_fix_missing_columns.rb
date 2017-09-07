class FixMissingColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email, :string
    add_reference :locations, :user
    add_timestamps :addresses, null: true
    add_timestamps :locations, null: true
  end
end
