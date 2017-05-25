require 'factory_girl_rails'

if Rails.env.development?
  create_list :user, 10
  User.all.each_slice(2) do |users|
    create :org, users: users
  end
end
