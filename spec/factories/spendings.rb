FactoryBot.define do
  factory :spending do
    association :user, factory: :user
    association :category, factory: :category
    amount { FFaker::Number.decimal }
    description { FFaker::Lorem.paragraph }

    trait :empty_amount do
      amount { nil }
    end

    trait :without_user_and_category do
      user { nil }
      category { nil }
    end
  end
end
