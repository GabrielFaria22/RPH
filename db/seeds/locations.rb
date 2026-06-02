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

      tamriel = Helpers.upsert_location(
        world: context.fetch(:nirn),
        name: 'Tamriel',
        location_type: 'continent',
        brief_description: 'The central continent of Nirn and the primary setting of The Elder Scrolls.',
        full_description: 'Tamriel is divided into culturally distinct provinces, including Skyrim, Cyrodiil, Morrowind, Black Marsh, Hammerfell, High Rock, Valenwood, Elsweyr, and Summerset.'
      )

      skyrim = Helpers.upsert_location(
        world: context.fetch(:nirn),
        parent_location: tamriel,
        name: 'Skyrim',
        location_type: 'province',
        brief_description: 'The cold northern homeland of the Nords, known for mountains, jarls, ancient ruins, and dragons.'
      )

      cyrodiil = Helpers.upsert_location(
        world: context.fetch(:nirn),
        parent_location: tamriel,
        name: 'Cyrodiil',
        location_type: 'province',
        brief_description: 'The central Imperial province and seat of the Imperial City.'
      )

      morrowind = Helpers.upsert_location(
        world: context.fetch(:nirn),
        parent_location: tamriel,
        name: 'Morrowind',
        location_type: 'province',
        brief_description: 'The volcanic northeastern homeland of the Dunmer, shaped by Great Houses and the legacy of Red Mountain.'
      )

      black_marsh = Helpers.upsert_location(
        world: context.fetch(:nirn),
        parent_location: tamriel,
        name: 'Black Marsh',
        location_type: 'province',
        brief_description: 'The marshy southeastern homeland of the Argonians, filled with swamps, Hist trees, and difficult terrain.'
      )

      hammerfell = Helpers.upsert_location(
        world: context.fetch(:nirn),
        parent_location: tamriel,
        name: 'Hammerfell',
        location_type: 'province',
        brief_description: 'The western homeland of the Redguards, known for deserts, coastlines, swordsmanship, and independent politics.'
      )

      high_rock = Helpers.upsert_location(
        world: context.fetch(:nirn),
        parent_location: tamriel,
        name: 'High Rock',
        location_type: 'province',
        brief_description: 'The northwestern homeland of the Bretons, marked by kingdoms, knightly orders, and political intrigue.'
      )

      valenwood = Helpers.upsert_location(
        world: context.fetch(:nirn),
        parent_location: tamriel,
        name: 'Valenwood',
        location_type: 'province',
        brief_description: 'The forested southwestern homeland of the Bosmer, known for dense living woods and the Green Pact.'
      )

      elsweyr = Helpers.upsert_location(
        world: context.fetch(:nirn),
        parent_location: tamriel,
        name: 'Elsweyr',
        location_type: 'province',
        brief_description: 'The southern homeland of the Khajiit, ranging from arid badlands to humid jungles.'
      )

      summerset = Helpers.upsert_location(
        world: context.fetch(:nirn),
        parent_location: tamriel,
        name: 'Summerset',
        location_type: 'province',
        brief_description: 'The island homeland of the Altmer, associated with ancient magical tradition and refined high elven culture.'
      )

      whiterun = Helpers.upsert_location(
        world: context.fetch(:nirn),
        parent_location: skyrim,
        name: 'Whiterun',
        location_type: 'hold capital',
        brief_description: 'A central Skyrim city ruled from Dragonsreach by Jarl Balgruuf the Greater.'
      )

      {
        star_wars_galaxy: star_wars_galaxy,
        outer_rim: outer_rim,
        mos_espa: mos_espa,
        westeros: westeros,
        the_north_location: the_north_location,
        winterfell: winterfell,
        tamriel: tamriel,
        skyrim: skyrim,
        cyrodiil: cyrodiil,
        morrowind: morrowind,
        black_marsh: black_marsh,
        hammerfell: hammerfell,
        high_rock: high_rock,
        valenwood: valenwood,
        elsweyr: elsweyr,
        summerset: summerset,
        whiterun: whiterun
      }
    end
  end
end
