FactoryGirl.define do
  factory :event do
    point_reward 5
    sequence(:name) { |n| "event#{n}" }
    sequence(:description) { |n| "event#{n} description" }

    start_time {Time.current}
    end_time {Time.current}

  end
end
