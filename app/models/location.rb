class Location < ActiveRecord::Base
  validates :long, :lat, :user, presence: true
end
