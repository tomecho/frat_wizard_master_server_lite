class User < ActiveRecord::Base
  has_many :location

  def latest_location
    self.location.order("updated_at DESC").first if self.location
  end
end
