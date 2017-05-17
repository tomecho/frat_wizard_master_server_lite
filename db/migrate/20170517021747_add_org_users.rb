class AddOrgUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :org_users do |f|
      f.integer :org_id
      f.integer :user_id
    end

    remove_column :users, :org_id
  end
end
