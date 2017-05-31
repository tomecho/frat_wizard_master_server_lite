class Group < ActiveRecord::Base
  belongs_to :org

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  has_many :groups_permissions, dependent: :destroy
  has_many :permissions, through: :groups_permissions

  validates :name, :description, :org, presence: true
  validates :name, :description, uniqueness: { scope: :org_id }
end
