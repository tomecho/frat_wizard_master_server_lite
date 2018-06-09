FactoryGirl.define do
  factory :user do
    name { random_name }
    password 'password'
    email { "fake#{random_name}@example.com" }
  end
end

def random_name
  ('a'..'z').to_a.shuffle.join
end
