module Seeds
  module Universes
    module_function

    def call(context)
      admin_user = context.fetch(:admin_user)

      star_wars = Helpers.upsert_universe(
        user: admin_user,
        name: 'Star Wars',
        genre: 'space opera',
        description: 'A space-opera universe of Jedi, Sith, planetary cultures, galactic governments, rebellions, and underworld syndicates.'
      )

      legacy_ice_and_fire = admin_user.universes.find_by(name: 'A World of Ice and Fire')
      if legacy_ice_and_fire && admin_user.universes.where(name: 'A Song of Ice and Fire').none?
        legacy_ice_and_fire.update!(name: 'A Song of Ice and Fire')
      end

      ice_and_fire = Helpers.upsert_universe(
        user: admin_user,
        name: 'A Song of Ice and Fire',
        genre: 'fantasy',
        description: 'George R. R. Martin\'s low-fantasy world of dynastic houses, court politics, war, prophecy, and ancient northern magic.'
      )

      elder_scrolls = Helpers.upsert_universe(
        user: admin_user,
        name: 'The Elder Scrolls',
        genre: 'fantasy',
        description: 'A high-fantasy universe set across Mundus, with divine myths, ancient races, Daedric powers, and continent-spanning empires.'
      )

      marvel = Helpers.upsert_universe(
        user: admin_user,
        name: 'Marvel',
        genre: 'superhero',
        description: 'A superhero universe of costumed vigilantes, spies, street-level defenders, cosmic threats, and complicated moral codes.'
      )

      dc = Helpers.upsert_universe(
        user: admin_user,
        name: 'DC',
        genre: 'superhero',
        description: 'A superhero universe of iconic cities, masked protectors, metahumans, vigilantes, and legendary teams.'
      )

      {
        star_wars: star_wars,
        ice_and_fire: ice_and_fire,
        elder_scrolls: elder_scrolls,
        marvel: marvel,
        dc: dc
      }
    end
  end
end
