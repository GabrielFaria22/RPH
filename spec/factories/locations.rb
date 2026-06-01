FactoryBot.define do
  factory :location do
    sequence(:name) { |number| "Location #{number}" }
    location_type { "city" }
    brief_description { "A notable place." }
    full_description { "A notable place with a longer history." }
    public { false }
    universe
  end
end
