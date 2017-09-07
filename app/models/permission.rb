class Permission < ActiveRecord::Base
  # groups wont be very useful to look at, many groups over many orgs will have same permission
  has_many :group_permissions, dependent: :destroy
  has_many :groups, through: :group_permissions

  validates :action, :controller, presence: true
  validates :action, uniqueness: { scope: :controller }

  def name
    "#{controller.humanize.titleize} - #{action.humanize.titleize}"
  end

  def model
    return controller.classify.constantize
  rescue NameError
    return nil
  end

  def self.update_permissions_table
    ActiveRecord::Base.transaction do
      delete_outdated_permissions
      create_new_permissions
    end
  end

  def self.delete_outdated_permissions
    # Delete all permissions that do not map to a valid controller action
    Rails.application.eager_load!
    Permission.all.find_each do |permission|
      # first check if it is one of our special permissions
      next if SPECIAL_PERMS.include?(permission.attributes.slice('action', 'controller'))

      controller = ApplicationController.descendants.find { |c| c.name == "#{permission.controller}_controller".camelcase }
      # Destroy the permission if the controller doesn't exist
      if controller.nil?
        permission.destroy!
        next
      end

      # Destroy the permission if the action doesn't exist
      action = get_actions(controller).find { |a| a == permission.action.to_s }
      if action.nil?
        permission.destroy!
        next
      end
    end
  end

  def self.create_new_permissions
    # Create a new full access permission for all controller actions that do not have one
    ApplicationController.descendants.each do |controller| # get all children and grand children
      get_actions(controller).each do |action|
        Permission.find_or_create_by(controller: controller.name.gsub!('Controller', '').underscore, action: action)
      end
    end

    # Handle our special perms
    SPECIAL_PERMS.each do |p|
      Permission.where(p).first_or_create
    end
  end

  # method for perms generation
  private_class_method def self.get_actions(controller)
    controller.instance_methods(false).map(&:to_s) & controller.action_methods.to_a
  end
end
