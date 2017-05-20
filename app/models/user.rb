class User < ActiveRecord::Base
  self.per_page = 10
  has_many :location
  has_many :org_users
  has_many :orgs, through: :org_users
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  def name
    "#{first_name} #{last_name}"
  end

  def latest_location
    location.order('updated_at DESC').first if location
  end
end
