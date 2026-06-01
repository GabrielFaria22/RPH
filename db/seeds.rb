puts
puts '== RPH seed run started =='

require_relative 'seeds/helpers'
require_relative 'seeds/users'
require_relative 'seeds/universes'
require_relative 'seeds/worlds'
require_relative 'seeds/locations'
require_relative 'seeds/characters'
require_relative 'seeds/factions'
require_relative 'seeds/families'
require_relative 'seeds/relations'
require_relative 'seeds/family_trees'

def seed_step(label)
  puts
  puts "== #{label} =="
  result = yield
  puts "-- #{label} complete"
  result
end

context = {}

context.merge!(seed_step('Seeding users') do
  Seeds::Users.call
end)

context.merge!(seed_step('Seeding universes') do
  Seeds::Universes.call(context)
end)

context.merge!(seed_step('Seeding worlds') do
  Seeds::Worlds.call(context)
end)

context.merge!(seed_step('Seeding locations') do
  Seeds::Locations.call(context)
end)

context.merge!(seed_step('Seeding characters') do
  Seeds::Characters.call(context)
end)

context.merge!(seed_step('Seeding factions') do
  Seeds::Factions.call(context)
end)

context.merge!(seed_step('Seeding families') do
  Seeds::Families.call(context)
end)

context.merge!(seed_step('Seeding character relations') do
  Seeds::Relations.call(context)
end)

seed_step('Seeding family trees') do
  Seeds::FamilyTrees.call(context)
end

puts
puts '== RPH seed run finished =='
