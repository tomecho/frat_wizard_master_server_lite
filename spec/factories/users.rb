FactoryGirl.define do
  factory :user do
    first_name 'pablo'
    sequence(:last_name) { |n| "escabar#{n}" }
    sequence(:email) { |n| "fake#{n}@example.com" }
  end
end
