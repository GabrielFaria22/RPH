FactoryBot.define do
  factory :person do
    first_name { "Ada" }
    last_name { "Lovelace" }
    sequence(:email) { |number| "person#{number}@example.com" }
    phone { "555-0100" }
    user
  end
end
