FactoryBot.define do
  factory :faction_relation do
    faction
    related_faction { association(:faction, universe: faction.universe) }
    relation_type { :alliance }
  end
end
