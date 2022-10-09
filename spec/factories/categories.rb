FactoryBot.define do
  factory :category do
    association :user, factory: :user
    name { FFaker::BaconIpsum.word }
    body { FFaker::HipsterIpsum.sentence }
    display { FFaker::Boolean.random }

    trait :empty_name do
      heading { nil }
    end

    trait :without_user do
      user { nil }
    end
  end
end
