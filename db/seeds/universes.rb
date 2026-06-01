module Seeds
  module Universes
    module_function

    def call(context)
      admin_user = context.fetch(:admin_user)

      star_wars = Helpers.upsert_universe(
        user: admin_user,
        name: 'Star Wars',
        genre: 'space opera',
        description: 'A galaxy far, far away.'
      )

      ice_and_fire = Helpers.upsert_universe(
        user: admin_user,
        name: 'A World of Ice and Fire',
        genre: 'fantasy',
        description: 'The known world of Westeros, Essos, and beyond.'
      )

      {
        star_wars: star_wars,
        ice_and_fire: ice_and_fire
      }
    end
  end
end
