FactoryBot.define do
  factory :family_relation do
    family
    related_family { association(:family, universe: family.universe) }
    relation_type { :friendship }
  end
end
