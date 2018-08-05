class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  self.per_page = 10
  has_many :location
  has_many :org_users
  has_many :orgs, through: :org_users
  has_many :group_users
  has_many :groups, through: :group_users
  validates :email, :name, presence: true
  validates :email, uniqueness: true

  def use_org_claim_code(code)
    claim = OrgClaimCode.find_by code: code
    if claim
      self.orgs << claim.org
      return claim.org
    end
  end

  def latest_location
    location.order('updated_at DESC').first if location
  end

  def has_permission?(controller, action)
    # Get a list of permissions associated with this controller and action
    relevant_permissions = GroupUser.where(user_id: self.id).map do |x|
      x.group.permissions.where(controller: controller, action: action)
        .or(x.group.permissions.where(controller: '*', action: '*'))
    end.flatten

    # Deny if the list is empty, permit if list is populated
    return relevant_permissions.any?
  end

  def is_super_user?
    return has_permission?('*', '*')
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end
