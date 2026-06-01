module Seeds
  module Families
    module_function

    def call(context)
      house_stark = Helpers.upsert_family(
        universe: context.fetch(:ice_and_fire),
        leader_character: context.fetch(:eddard_stark),
        faction: context.fetch(:the_north),
        name: 'House Stark',
        description: 'The ruling house of Winterfell and the North.'
      )

      [
        context.fetch(:eddard_stark),
        context.fetch(:jon_snow),
        context.fetch(:sansa_stark),
        context.fetch(:arya_stark)
      ].each do |character|
        character.update!(family: house_stark, faction: context.fetch(:the_north))
      end

      { house_stark: house_stark }
    end
  end
end
