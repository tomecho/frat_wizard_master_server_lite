class Location < ActiveRecord::Base
  belongs_to :user
  validates :long, :lat, :user_id, presence: true
  # on create find old location and set :most_recent = false

  RADIUS = 400 # max radius is 400
  def within(point2)
    Geocoder::Calculations.distance_between([lat, long], point2, units: :feet) < RADIUS
  end
end
