class Permission < ActiveRecord::Base
  # groups wont be very useful to look at, many groups over many orgs will have same permission
  has_many :group_permissions, dependent: :destroy
  has_many :groups, through: :group_permissions

  validates :action, :controller, uniqueness: true
end
