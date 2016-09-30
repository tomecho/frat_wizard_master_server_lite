class Location < ActiveRecord::Base
  belongs_to :user
  validates :long, :lat, :user_id, presence: true
  RADIUS = 0.0757576 # max radius is 400 feet or 0.0757576 miles

  def self.default_radius
    RADIUS
  end

  def within(point2)
    return unless point2[0].present? && point2[1].present?
    Geocoder::Calculations.distance_between([lat, long], point2, units: :mi) < RADIUS
  end

  def self.latest
    Location.group(:user_id).having('updated_at = MAX(updated_at)')
  end
end
