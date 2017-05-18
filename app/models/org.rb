class Org < ActiveRecord::Base
  validates :name, presence: true
  has_one :address
  has_many :org_users
  has_many :users, through: :org_users
end
