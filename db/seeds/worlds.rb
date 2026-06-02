module Seeds
  module Worlds
    module_function

    def call(context)
      tatooine = Helpers.upsert_world(
        universe: context.fetch(:star_wars),
        name: 'Tatooine',
        description: 'A harsh Outer Rim desert world with twin suns, moisture farms, spaceports, and a long history of underworld influence.'
      )

      coruscant = Helpers.upsert_world(
        universe: context.fetch(:star_wars),
        name: 'Coruscant',
        description: 'A city-covered Core World that served as the galactic capital for the Republic and later the Empire.'
      )

      yavin_iv = Helpers.upsert_world(
        universe: context.fetch(:star_wars),
        name: 'Yavin IV',
        description: 'A jungle moon used by the Rebel Alliance as a hidden base during the struggle against the Death Star.'
      )

      mandalore = Helpers.upsert_world(
        universe: context.fetch(:star_wars),
        name: 'Mandalore',
        description: 'The ancestral homeworld of the Mandalorians, defined by warrior traditions, political upheaval, and repeated devastation.'
      )

      geonosis = Helpers.upsert_world(
        universe: context.fetch(:star_wars),
        name: 'Geonosis',
        description: 'A rocky Outer Rim world whose droid foundries helped ignite the Clone Wars.'
      )

      kamino = Helpers.upsert_world(
        universe: context.fetch(:star_wars),
        name: 'Kamino',
        description: 'An ocean world known for advanced cloning facilities and the creation of the Republic clone army.'
      )

      planetos = Helpers.upsert_world(
        universe: context.fetch(:ice_and_fire),
        name: 'Planetos',
        description: 'The world containing Westeros and Essos.'
      )

      nirn = Helpers.upsert_world(
        universe: context.fetch(:elder_scrolls),
        name: 'Nirn',
        description: 'The mortal planet of The Elder Scrolls, home to Tamriel, Akavir, Atmora, Yokuda, and other storied lands.'
      )

      {
        tatooine: tatooine,
        coruscant: coruscant,
        yavin_iv: yavin_iv,
        mandalore: mandalore,
        geonosis: geonosis,
        kamino: kamino,
        planetos: planetos,
        nirn: nirn
      }
    end
  end
end
