FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "name#{n}" }
    sequence(:description) { |n| "desc#{n}" }
    association :org
  end
end
