class User < ActiveRecord::Base
  has_many :location
  has_many :orgs, through: :org_users
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
  self.per_page = 10

  def name
    "#{first_name} #{last_name}"
  end

  def latest_location
    location.order('updated_at DESC').first if location
  end
end
