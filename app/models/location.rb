class Location < ActiveRecord::Base
  validates :long, :lat, presence: true
end
