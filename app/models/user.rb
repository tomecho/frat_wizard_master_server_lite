class User < ActiveRecord::Base
  has_many :location
  validates :first_name, :last_name, :location_enabled, presence: true
end
