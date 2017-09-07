class OrgClaimCode < ActiveRecord::Base
  belongs_to :org
  validates :org, :code, presence: true
  validates :code, uniqueness: true

  before_validation :generate_code
  def generate_code
    self.code = SecureRandom.base58(24)
  end
end
