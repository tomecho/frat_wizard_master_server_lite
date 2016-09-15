class User < ActiveRecord::Base
  has_many :location
  validates :first_name, :last_name, :email, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def latest_location
    self.location.order("updated_at DESC").first if self.location
  end
end
