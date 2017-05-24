class User < ActiveRecord::Base
  self.per_page = 10
  has_many :location
  has_many :org_users
  has_many :orgs, through: :org_users
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
  after_initialize :add_org_claim_code
  before_save :use_org_claim_code

  def use_org_claim_code
    claim = OrgClaimCode.find_by code: self.org_claim_code
    self.orgs << claim.org if claim
    # if we couldnt find the claim we can still create the user
  end

  def add_org_claim_code
    # just a single claim code available for user creation
    self.class_eval { attr_accessor :org_claim_code } if new_record?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def latest_location
    location.order('updated_at DESC').first if location
  end

  def has_permission?(controller, action)
    # Get a list of permissions associated with this controller and action
    relevant_permissions = GroupsUser.where(user_id: self.id, active: true).map do |x|
      x.group.permissions.where(active: true, controller: controller, action: action)
    end.flatten

    # Deny if the list is empty, permit if list is populated
    return relevant_permissions.any?
  end

  def is_super_user
    return has_permission?('*', '*')
  end
end
