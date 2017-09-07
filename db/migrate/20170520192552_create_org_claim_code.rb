class CreateOrgClaimCode < ActiveRecord::Migration[5.0]
  def change
    create_table :org_claim_codes do |t|
      t.references :org, foreign_key: true
      t.string :code
      t.timestamps
    end
  end
end
