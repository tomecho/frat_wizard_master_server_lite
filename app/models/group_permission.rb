class GroupPermission < ActiveRecord::Base
  belongs_to :group
  belongs_to :permission
  validates :group, :permission, presence: true
end
