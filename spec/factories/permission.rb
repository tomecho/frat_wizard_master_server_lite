FactoryGirl.define do
  factory :permission do
    sequence(:controller) { |n| "controller#{n}"}
    sequence(:action) { |n| "action#{n}"}
  end
end
