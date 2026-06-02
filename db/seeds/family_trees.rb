module Seeds
  module FamilyTrees
    module_function

    def call(context)
      house_stark = context.fetch(:house_stark)
      eddard_stark = context.fetch(:eddard_stark)
      catelyn_stark = context.fetch(:catelyn_stark)
      jon_snow = context.fetch(:jon_snow)
      robb_stark = context.fetch(:robb_stark)
      sansa_stark = context.fetch(:sansa_stark)
      arya_stark = context.fetch(:arya_stark)

      house_stark.family_tree.update!(
        name: 'House Stark Family Tree',
        description: 'Eddard and Catelyn Stark are the parents of Robb, Sansa, and Arya Stark; Jon Snow is raised at Winterfell as Eddard Stark\'s acknowledged bastard son.',
        public: true,
        layout: {
          'nodes' => [
            { 'id' => "character-#{eddard_stark.id}", 'character_id' => eddard_stark.id, 'x' => -160, 'y' => 0 },
            { 'id' => "character-#{catelyn_stark.id}", 'character_id' => catelyn_stark.id, 'x' => 160, 'y' => 0 },
            { 'id' => "character-#{jon_snow.id}", 'character_id' => jon_snow.id, 'x' => -360, 'y' => 240 },
            { 'id' => "character-#{robb_stark.id}", 'character_id' => robb_stark.id, 'x' => -120, 'y' => 240 },
            { 'id' => "character-#{sansa_stark.id}", 'character_id' => sansa_stark.id, 'x' => 120, 'y' => 240 },
            { 'id' => "character-#{arya_stark.id}", 'character_id' => arya_stark.id, 'x' => 360, 'y' => 240 }
          ],
          'edges' => (context.fetch(:stark_spouse_relations) + context.fetch(:stark_parent_relations) + [context.fetch(:stark_acknowledged_parent_relation)]).map do |relation|
            {
              'id' => "relation-#{relation.id}",
              'relation_id' => relation.id,
              'source' => "character-#{relation.character_id}",
              'target' => "character-#{relation.related_character_id}",
              'relation_type' => relation.relation_type
            }
          end,
          'viewport' => {
            'x' => 0,
            'y' => 0,
            'zoom' => 1
          }
        }
      )
    end
  end
end
