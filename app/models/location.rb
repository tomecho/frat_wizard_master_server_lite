class Location < ActiveRecord::Base
  belongs_to :user
  validates :long, :lat, :user, presence: true
  #after_create :update_active
  
end
