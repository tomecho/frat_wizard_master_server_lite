class OrgUsers < ActiveRecord::Base
  belongs_to :user
  belongs_to :org
  validates :user, :org, presence: true
end
