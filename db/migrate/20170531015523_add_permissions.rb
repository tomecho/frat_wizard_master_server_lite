class AddPermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :permissions do |t|
      t.string :controller
      t.string :action

      t.timestamps
    end

    create_table :group_permissions do |t|
      t.references :group
      t.references :permission
      t.timestamps
    end
  end
end
