class Location < ActiveRecord::Base
  validates :long, :lat, presence: true
  # on create find old location and set :most_recent = false
end
