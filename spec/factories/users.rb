FactoryBot.define do
  factory :user do
    username { FFaker::Internet.unique.user_name.ljust(User::USERNAME_MIN_LENGTH, 'a')[0...User::USERNAME_MAX_LENGTH] }
    password { 'Password7&' }

    trait :with_empty_username do
      username { nil }
    end

    trait :with_empty_password do
      password_digest { nil }
    end
  end
end
