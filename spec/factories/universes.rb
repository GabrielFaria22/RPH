FactoryBot.define do
  factory :universe do
    sequence(:name) { |number| "Universe #{number}" }
    genre { 'other' }
    description { "A fictional continuity." }
    public { false }
    user
  end
end
