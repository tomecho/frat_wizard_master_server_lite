class User < ActiveRecord::Base
  self.per_page = 10
  has_many :location
  has_many :org_users
  has_many :orgs, through: :org_users
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
  before_save :use_org_claim_code

  # just a single claim code available for user creation
  attr_accessor :org_claim_code unless self.persisted?
  def use_org_claim_code
    claim = OrgClaimCode.find_by self.org_claim_code
    self.orgs << claim.org if claim
    # if we couldnt find the claim we can still create the user
  end

  def name
    "#{first_name} #{last_name}"
  end

  def latest_location
    location.order('updated_at DESC').first if location
  end
end
