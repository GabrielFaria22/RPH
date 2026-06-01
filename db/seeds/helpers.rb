module Seeds
  module Helpers
    module_function

    def upsert_universe(user:, name:, genre:, description: nil, public: true)
      universe = user.universes.find_or_initialize_by(name: name)
      universe.assign_attributes(genre: genre, description: description, public: public)
      universe.save!
      universe
    end

    def upsert_world(universe:, name:, description: nil, public: true)
      world = universe.worlds.find_or_initialize_by(name: name)
      world.assign_attributes(description: description, public: public)
      world.save!
      world
    end

    def upsert_location(universe: nil, world: nil, parent_location: nil, name:, location_type: nil, brief_description: nil, full_description: nil, public: true)
      scope = world.present? ? world.locations : universe.locations
      location = scope.find_or_initialize_by(name: name)
      location.assign_attributes(
        universe: universe,
        world: world,
        parent_location: parent_location,
        location_type: location_type,
        brief_description: brief_description,
        full_description: full_description,
        public: public
      )
      location.save!
      location
    end

    def upsert_character(universe:, world:, name:, attributes: {})
      character = universe.characters.find_or_initialize_by(name: name)
      character.assign_attributes(attributes.merge(world: world, public: attributes.fetch(:public, true)))
      character.save!
      character
    end

    def attach_seed_image(record, attachment_name, *path_segments)
      attachment = record.public_send(attachment_name)
      return if attachment.attached?

      path = Rails.root.join('db', 'seeds', 'assets', *path_segments)
      unless File.exist?(path)
        puts "-- Missing seed image: #{path}"
        return
      end

      File.open(path, 'rb') do |file|
        attachment.attach(
          io: file,
          filename: File.basename(path),
          content_type: Marcel::MimeType.for(Pathname.new(path))
        )
      end
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
  end
end
