FactoryGirl.define do
  factory :goal do
    title { "Vacation to " + Faker::Address.country }
    amount { Faker::Number.between(500, 10000) }
    due_date { Faker::Date.forward(30) }
    filepicker_url nil
  end
end