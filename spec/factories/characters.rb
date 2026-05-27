FactoryBot.define do
  factory :character do
    sequence(:name) { |number| "Character #{number}" }
    full_name { "Character Full Name" }
    nickname { "The Example" }
    age { "1000001" }
    appearance { "Distinctive" }
    occupation { "Adventurer" }
    description { "Short description." }
    story { "Longer story." }
    universe
  end
end
