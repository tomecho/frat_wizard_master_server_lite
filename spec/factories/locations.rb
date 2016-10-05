FactoryGirl.define do
  factory :location do
    association :user
    long 1
    lat 1
  end
end
