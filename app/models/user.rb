class User < ActiveRecord::Base
  has_many :location

  def name
    "#{first_name} #{last_name}"
  end

  def latest_location
    self.location.order("updated_at DESC").first if self.location
  end
end
