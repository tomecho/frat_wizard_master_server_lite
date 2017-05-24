class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.references :org, foreign_key: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
