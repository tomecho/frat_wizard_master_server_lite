class Group < ActiveRecord::Base
  belongs_to :org
  has_many :group_users
  has_many :users, through: :group_users
end
