FactoryBot.define do
  factory :universe do
    sequence(:name) { |number| "Universe #{number}" }
    description { "A fictional continuity." }
    public { false }
    user
  end
end
