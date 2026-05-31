FactoryBot.define do
  factory :family_tree do
    sequence(:name) { |number| "Family Tree #{number}" }
    description { "A saved family tree view." }
    public { false }
    layout { {} }
    universe
  end
end
