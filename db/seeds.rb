admin_user = User.find_or_initialize_by(email: 'gabrielfca222@gmail.com')
admin_user.password = 'londrina1993'
admin_user.password_confirmation = 'londrina1993'
admin_user.profile_type = 'admin'
admin_user.save!

admin_person = admin_user.people.first_or_initialize
admin_person.assign_attributes(
  first_name: 'Gabriel',
  last_name: 'Admin',
  email: admin_user.email
)
admin_person.save!

def upsert_universe(user:, name:, description: nil, public: true)
  universe = user.universes.find_or_initialize_by(name: name)
  universe.assign_attributes(description: description, public: public)
  universe.save!
  universe
end

def upsert_world(universe:, name:, description: nil, public: true)
  world = universe.worlds.find_or_initialize_by(name: name)
  world.assign_attributes(description: description, public: public)
  world.save!
  world
end

def upsert_character(universe:, world:, name:, attributes: {})
  character = universe.characters.find_or_initialize_by(name: name)
  character.assign_attributes(attributes.merge(world: world, public: attributes.fetch(:public, true)))
  character.save!
  character
end

def upsert_faction(universe:, leader_character:, name:, description: nil, public: true)
  faction = universe.factions.find_or_initialize_by(name: name)
  faction.assign_attributes(
    description: description,
    public: public,
    leader_character: leader_character
  )
  faction.save!
  faction
end

def upsert_family(universe:, leader_character:, faction:, name:, description: nil, public: true)
  family = universe.families.find_or_initialize_by(name: name)
  family.assign_attributes(
    description: description,
    public: public,
    leader_character: leader_character,
    faction: faction
  )
  family.save!
  family
end

def upsert_character_relation(character:, related_character:, relation_type:)
  relation = Relation.find_or_initialize_by(
    character: character,
    related_character: related_character,
    relation_type: relation_type
  )
  relation.save!
  relation
end

star_wars = upsert_universe(
  user: admin_user,
  name: 'Star Wars',
  description: 'A galaxy far, far away.'
)

tatooine = upsert_world(
  universe: star_wars,
  name: 'Tatooine',
  description: 'A desert world with twin suns.'
)

boba_fett = upsert_character(
  universe: star_wars,
  world: tatooine,
  name: 'Boba Fett',
  attributes: {
    occupation: 'Bounty hunter',
    description: 'A feared Mandalorian bounty hunter operating across the galaxy.'
  }
)

hutt_cartel = upsert_faction(
  universe: star_wars,
  leader_character: boba_fett,
  name: 'Hutt Cartel',
  description: 'A powerful criminal syndicate with deep roots in the Outer Rim.'
)
boba_fett.update!(family: nil, faction: hutt_cartel)

ice_and_fire = upsert_universe(
  user: admin_user,
  name: 'A World of Ice and Fire',
  description: 'The known world of Westeros, Essos, and beyond.'
)

planetos = upsert_world(
  universe: ice_and_fire,
  name: 'Planetos',
  description: 'The world containing Westeros and Essos.'
)

eddard_stark = upsert_character(
  universe: ice_and_fire,
  world: planetos,
  name: 'Eddard Stark',
  attributes: {
    nickname: 'Ned',
    occupation: 'Lord of Winterfell',
    description: 'Patriarch of House Stark and Warden of the North.'
  }
)

jon_snow = upsert_character(
  universe: ice_and_fire,
  world: planetos,
  name: 'Jon Snow',
  attributes: {
    occupation: 'Night\'s Watch steward',
    description: 'Raised at Winterfell as Eddard Stark\'s son.'
  }
)

sansa_stark = upsert_character(
  universe: ice_and_fire,
  world: planetos,
  name: 'Sansa Stark',
  attributes: {
    occupation: 'Lady of Winterfell',
    description: 'Daughter of Eddard Stark.'
  }
)

arya_stark = upsert_character(
  universe: ice_and_fire,
  world: planetos,
  name: 'Arya Stark',
  attributes: {
    occupation: 'Noblewoman',
    description: 'Daughter of Eddard Stark.'
  }
)

the_north = upsert_faction(
  universe: ice_and_fire,
  leader_character: eddard_stark,
  name: 'The North',
  description: 'The northern kingdom and its loyal houses.'
)

house_stark = upsert_family(
  universe: ice_and_fire,
  leader_character: eddard_stark,
  faction: the_north,
  name: 'House Stark',
  description: 'The ruling house of Winterfell and the North.'
)

[eddard_stark, jon_snow, sansa_stark, arya_stark].each do |character|
  character.update!(family: house_stark, faction: the_north)
end

children = [jon_snow, sansa_stark, arya_stark]
parent_relations = children.map do |child|
  upsert_character_relation(character: eddard_stark, related_character: child, relation_type: 'parent')
end
children.each do |child|
  upsert_character_relation(character: child, related_character: eddard_stark, relation_type: 'child')
end

house_stark.family_tree.update!(
  name: 'House Stark Family Tree',
  description: 'Eddard Stark is the father of Jon Snow, Sansa Stark, and Arya Stark.',
  public: true,
  layout: {
    'nodes' => [
      { 'id' => "character-#{eddard_stark.id}", 'character_id' => eddard_stark.id, 'x' => 0, 'y' => 0 },
      { 'id' => "character-#{jon_snow.id}", 'character_id' => jon_snow.id, 'x' => -240, 'y' => 220 },
      { 'id' => "character-#{sansa_stark.id}", 'character_id' => sansa_stark.id, 'x' => 0, 'y' => 220 },
      { 'id' => "character-#{arya_stark.id}", 'character_id' => arya_stark.id, 'x' => 240, 'y' => 220 }
    ],
    'edges' => parent_relations.map do |relation|
      {
        'id' => "relation-#{relation.id}",
        'relation_id' => relation.id,
        'source' => "character-#{relation.character_id}",
        'target' => "character-#{relation.related_character_id}",
        'relation_type' => relation.relation_type
      }
    end,
    'viewport' => {
      'x' => 0,
      'y' => 0,
      'zoom' => 1
    }
  }
)
