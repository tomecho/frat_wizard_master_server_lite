require 'factory_girl_rails'

if Rails.env.development?
  FactoryGirl.create_list :user, 10
  User.all.each_slice(2) do |users|
    FactoryGirl.create :org, users: users
  end
end
