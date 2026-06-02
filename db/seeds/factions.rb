module Seeds
  module Factions
    module_function

    def call(context)
      galactic_republic = Helpers.upsert_faction(
        universe: context.fetch(:star_wars),
        leader_character: context.fetch(:padme_amidala),
        name: 'Galactic Republic',
        description: 'The ancient democratic government centered on Coruscant, defended by the Jedi Order and later drawn into the Clone Wars.'
      )

      cis = Helpers.upsert_faction(
        universe: context.fetch(:star_wars),
        leader_character: context.fetch(:darth_maul),
        name: 'CIS',
        description: 'The Confederacy of Independent Systems, a Separatist alliance that opposed the Galactic Republic during the Clone Wars.'
      )

      empire = Helpers.upsert_faction(
        universe: context.fetch(:star_wars),
        leader_character: context.fetch(:darth_vader),
        name: 'Empire',
        description: 'The authoritarian Galactic Empire that rose from the Republic and ruled through military force, fear, and the dark side.'
      )

      rebels = Helpers.upsert_faction(
        universe: context.fetch(:star_wars),
        leader_character: context.fetch(:leia_organa),
        name: 'Rebels',
        description: 'The Rebel Alliance, a coalition of resistance cells committed to overthrowing the Galactic Empire and restoring freedom.'
      )

      hutt_cartel = Helpers.upsert_faction(
        universe: context.fetch(:star_wars),
        leader_character: context.fetch(:bobba_fett),
        name: 'Hutt Cartel',
        description: 'A powerful criminal syndicate with deep roots in the Outer Rim, centered on Hutt clan wealth and underworld influence.'
      )

      context.fetch(:padme_amidala).update!(family: nil, faction: galactic_republic)
      context.fetch(:darth_vader).update!(family: nil, faction: empire)
      context.fetch(:luke_skywalker).update!(family: nil, faction: rebels)
      context.fetch(:leia_organa).update!(family: nil, faction: rebels)
      context.fetch(:bobba_fett).update!(family: nil, faction: hutt_cartel)

      the_north = Helpers.upsert_faction(
        universe: context.fetch(:ice_and_fire),
        leader_character: context.fetch(:eddard_stark),
        name: 'The North',
        description: 'The vast northern region of Westeros and its loyal houses, traditionally ruled from Winterfell by House Stark.'
      )

      {
        galactic_republic: galactic_republic,
        cis: cis,
        empire: empire,
        rebels: rebels,
        hutt_cartel: hutt_cartel,
        the_north: the_north
      }
    end
  end
end
