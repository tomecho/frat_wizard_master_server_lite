class User < ActiveRecord::Base
  has_one :address
  validates :first_name, :last_name, presence: true
end
