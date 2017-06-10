FactoryGirl.define do
  factory :user do
    first_name 'pablo'
    sequence(:last_name) { |n| "escabar#{n}" }
    email { "fake#{ ->() { (0...50).map { ('a'..'z').to_a[rand(26)] }.join.to_s } }@example.com" }
  end
end
