module Seeds
  module Characters
    module_function

    def call(context)
      boba_fett = Helpers.upsert_character(
        universe: context.fetch(:star_wars),
        world: context.fetch(:tatooine),
        name: 'Bobba Fett',
        attributes: {
          occupation: 'Bounty hunter',
          description: 'A feared Mandalorian bounty hunter operating across the galaxy.'
        }
      )
      Helpers.attach_seed_image(boba_fett, :portrait_image, 'portraits', 'star wars', 'bobba.png')

      eddard_stark = Helpers.upsert_character(
        universe: context.fetch(:ice_and_fire),
        world: context.fetch(:planetos),
        name: 'Eddard Stark',
        attributes: {
          nickname: 'Ned',
          occupation: 'Lord of Winterfell',
          description: 'Patriarch of House Stark and Warden of the North.'
        }
      )

      jon_snow = Helpers.upsert_character(
        universe: context.fetch(:ice_and_fire),
        world: context.fetch(:planetos),
        name: 'Jon Snow',
        attributes: {
          occupation: 'Night\'s Watch steward',
          description: 'Raised at Winterfell as Eddard Stark\'s son.'
        }
      )

      sansa_stark = Helpers.upsert_character(
        universe: context.fetch(:ice_and_fire),
        world: context.fetch(:planetos),
        name: 'Sansa Stark',
        attributes: {
          occupation: 'Lady of Winterfell',
          description: 'Daughter of Eddard Stark.'
        }
      )

      arya_stark = Helpers.upsert_character(
        universe: context.fetch(:ice_and_fire),
        world: context.fetch(:planetos),
        name: 'Arya Stark',
        attributes: {
          occupation: 'Noblewoman',
          description: 'Daughter of Eddard Stark.'
        }
      )

      {
        boba_fett: boba_fett,
        eddard_stark: eddard_stark,
        jon_snow: jon_snow,
        sansa_stark: sansa_stark,
        arya_stark: arya_stark
      }
    end
  end
end
