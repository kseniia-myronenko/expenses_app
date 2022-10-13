FactoryBot.define do
  factory :category do
    association :user, factory: :user
    heading { FFaker::Name.unique.first_name }
    body { FFaker::HipsterIpsum.sentence }
    display { FFaker::Boolean.random }

    trait :empty_heading do
      heading { nil }
    end

    trait :without_user do
      user { nil }
    end
  end
end
