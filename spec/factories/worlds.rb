FactoryBot.define do
  factory :world do
    sequence(:name) { |number| "World #{number}" }
    description { "A place inside a universe." }
    universe
  end
end
