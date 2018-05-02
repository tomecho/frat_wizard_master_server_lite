class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :omniauthable
  self.per_page = 10
  has_many :location
  has_many :org_users
  has_many :orgs, through: :org_users
  has_many :group_users
  has_many :groups, through: :group_users
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  def use_org_claim_code(code)
    claim = OrgClaimCode.find_by code: code
    if claim
      self.orgs << claim.org
      return claim.org
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def latest_location
    location.order('updated_at DESC').first if location
  end

  def has_permission?(controller, action)
    # Get a list of permissions associated with this controller and action
    relevant_permissions = GroupUser.where(user_id: self.id).map do |x|
      x.group.permissions.where(controller: controller, action: action)
    end.flatten

    # Deny if the list is empty, permit if list is populated
    return relevant_permissions.any?
  end

  def is_super_user?
    return has_permission?('*', '*')
  end
end
