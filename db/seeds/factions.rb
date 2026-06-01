module Seeds
  module Factions
    module_function

    def call(context)
      hutt_cartel = Helpers.upsert_faction(
        universe: context.fetch(:star_wars),
        leader_character: context.fetch(:boba_fett),
        name: 'Hutt Cartel',
        description: 'A powerful criminal syndicate with deep roots in the Outer Rim.'
      )
      context.fetch(:boba_fett).update!(family: nil, faction: hutt_cartel)

      the_north = Helpers.upsert_faction(
        universe: context.fetch(:ice_and_fire),
        leader_character: context.fetch(:eddard_stark),
        name: 'The North',
        description: 'The northern kingdom and its loyal houses.'
      )

      {
        hutt_cartel: hutt_cartel,
        the_north: the_north
      }
    end
  end
end
