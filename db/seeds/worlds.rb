module Seeds
  module Worlds
    module_function

    def call(context)
      tatooine = Helpers.upsert_world(
        universe: context.fetch(:star_wars),
        name: 'Tatooine',
        description: 'A desert world with twin suns.'
      )

      planetos = Helpers.upsert_world(
        universe: context.fetch(:ice_and_fire),
        name: 'Planetos',
        description: 'The world containing Westeros and Essos.'
      )

      {
        tatooine: tatooine,
        planetos: planetos
      }
    end
  end
end
