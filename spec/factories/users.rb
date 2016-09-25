FactoryGirl.define do
  factory :user do
    first_name "pablo"
    last_name "escabar"
    sequence(:email) {|n| "fake#{n}@example.com" }
  end
end
