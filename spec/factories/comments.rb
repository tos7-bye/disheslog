FactoryBot.define do
  factory :comment do
    user_id { 1 }
    content { "味が薄いので、次は味を濃くする。" }
    association :dish
  end
end
