FactoryBot.define do
  factory :family do
    sequence(:name) { |number| "Family #{number}" }
    description { "A notable bloodline." }
    public { false }
    universe
    leader_character { association(:character, universe: universe) }
  end
end
