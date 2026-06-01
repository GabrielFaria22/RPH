module Seeds
  module Locations
    module_function

    def call(context)
      star_wars_galaxy = Helpers.upsert_location(
        universe: context.fetch(:star_wars),
        name: 'The Galaxy',
        location_type: 'galaxy',
        brief_description: 'The main galactic setting of Star Wars.',
        full_description: 'A vast galaxy of Core Worlds, Mid Rim systems, Outer Rim territories, hyperspace routes, and ancient conflicts.'
      )

      outer_rim = Helpers.upsert_location(
        universe: context.fetch(:star_wars),
        parent_location: star_wars_galaxy,
        name: 'Outer Rim Territories',
        location_type: 'region',
        brief_description: 'A distant and lawless galactic region.'
      )

      mos_espa = Helpers.upsert_location(
        world: context.fetch(:tatooine),
        parent_location: outer_rim,
        name: 'Mos Espa',
        location_type: 'city',
        brief_description: 'A spaceport city on Tatooine.'
      )

      westeros = Helpers.upsert_location(
        world: context.fetch(:planetos),
        name: 'Westeros',
        location_type: 'continent',
        brief_description: 'The western continent of the known world.'
      )

      the_north_location = Helpers.upsert_location(
        world: context.fetch(:planetos),
        parent_location: westeros,
        name: 'The North',
        location_type: 'region',
        brief_description: 'The cold northern region ruled from Winterfell.'
      )

      winterfell = Helpers.upsert_location(
        world: context.fetch(:planetos),
        parent_location: the_north_location,
        name: 'Winterfell',
        location_type: 'castle',
        brief_description: 'The ancestral seat of House Stark.'
      )

      {
        star_wars_galaxy: star_wars_galaxy,
        outer_rim: outer_rim,
        mos_espa: mos_espa,
        westeros: westeros,
        the_north_location: the_north_location,
        winterfell: winterfell
      }
    end
  end
end
