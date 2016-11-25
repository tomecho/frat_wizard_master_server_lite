class Org < ActiveRecord::Base
  validates :name, presence: true
  has_one :address
  has_many :users
end
