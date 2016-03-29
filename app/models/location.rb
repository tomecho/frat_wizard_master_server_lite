class Location < ActiveRecord::Base
  belongs_to :user
  validates :long, :lat, presence: true
  # on create find old location and set :most_recent = false
end
