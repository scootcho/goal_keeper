FactoryGirl.define do
  factory :expense do
    expense_date { Faker::Date.between(2.days.ago, Date.today) }
    description { Faker::Lorem.word }
    amount { Faker::Commerce.price }
    category 'Food & Dining'

    trait :auto_transport do
      category 'Auto & Transportation'
    end

    trait :food_dining do
      category 'Food & Dining'
    end

    trait :entertainment do
      category 'Entertaiment'
    end

    trait :bills do
      category 'Bills & Utilities'
    end

    trait :investment do
      category 'Investments'
    end

    trait :misc do
      category 'MISC'
    end
  end
end