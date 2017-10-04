class AddGroupUser < ActiveRecord::Migration[5.0]
  def change
    create_table :group_users do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
    end
  end
end
