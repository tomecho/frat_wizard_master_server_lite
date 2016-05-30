class Location < ActiveRecord::Base
  validates :street, :city, :state, :zip, presence: true
end
