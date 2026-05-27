FactoryBot.define do
  factory :relation do
    character
    related_character { association(:character, universe: character.universe) }
    relation_type { :friend }
  end
end
