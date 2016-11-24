class User < ActiveRecord::Base
  has_many :location
  validates :first_name, :last_name, :email, presence: true
  self.per_page = 10

  def name
    "#{first_name} #{last_name}"
  end

  def latest_location
    location.order('updated_at DESC').first if location
  end
end
