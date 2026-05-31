FactoryBot.define do
  factory :faction do
    sequence(:name) { |number| "Faction #{number}" }
    description { "A political group." }
    public { false }
    universe
    leader_character { association(:character, universe: universe) }
  end
end
