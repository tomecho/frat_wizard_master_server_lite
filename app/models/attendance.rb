class Attendance < ActiveRecord::Base
  belongs_to :event
  validates :points, presence: true
end
