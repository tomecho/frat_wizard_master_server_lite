class AddOrgRefToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :orgs
  end
end
