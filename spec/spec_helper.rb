require 'simplecov'
SimpleCov.start
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before :suite do
    Permission.update_permissions_table
  end

  config.before(:each) do
    current_user super_user
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def current_user(user = nil)
  @current_user = if user
                    user
                  else
                    create(:user)
                  end
  controller.instance_variable_set('@current_user', @current_user)
end

def super_user
  create(:user, groups: [create(:group, permissions: Permission.all)])
end
