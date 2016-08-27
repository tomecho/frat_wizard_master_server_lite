class Location < ActiveRecord::Base
  belongs_to :user
  validates :long, :lat, :user_id, presence: true
  # on create find old location and set :most_recent = false

  RADIUS = 0.0757576 # max radius is 400 feet or 0.0757576 miles
  def within(point2)
    Geocoder::Calculations.distance_between([self.lat, self.long], point2) < RADIUS
  end

  def self.latest
    Location.group(:user_id).having('updated_at = MAX(updated_at)')
  end
end
