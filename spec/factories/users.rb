FactoryBot.define do
  factory :user do
    sequence(:email) { |number| "user#{number}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    jti { SecureRandom.uuid }
    profile_type { :regular }

    trait :admin do
      profile_type { :admin }
    end
  end
end
