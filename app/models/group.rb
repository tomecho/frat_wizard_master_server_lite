class Group < ActiveRecord::Base
  belongs_to :org
  has_many :group_users
  has_many :users, through: :group_users
  validates :name, :description, :org, presence: true
  validates :name, :description, uniqueness: { scope: :org_id }
end
