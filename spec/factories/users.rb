FactoryGirl.define do
  factory :user do
    first_name 'pablo'
    sequence(:last_name) { |n| "escabar#{n}" }
    email { "fake#{random_name}@example.com" }
  end
end

def random_name
  ('a'..'z').to_a.shuffle.join
end
