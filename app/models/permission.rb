class Permission < ActiveRecord::Base
  has_many :group_permissions, dependent: :destroy
  has_many :groups, through: :group_permissions

  validates :action, :controller, uniqueness: true
end
