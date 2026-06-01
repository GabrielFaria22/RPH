module Seeds
  module FamilyTrees
    module_function

    def call(context)
      house_stark = context.fetch(:house_stark)
      eddard_stark = context.fetch(:eddard_stark)
      jon_snow = context.fetch(:jon_snow)
      sansa_stark = context.fetch(:sansa_stark)
      arya_stark = context.fetch(:arya_stark)

      house_stark.family_tree.update!(
        name: 'House Stark Family Tree',
        description: 'Eddard Stark is the father of Jon Snow, Sansa Stark, and Arya Stark.',
        public: true,
        layout: {
          'nodes' => [
            { 'id' => "character-#{eddard_stark.id}", 'character_id' => eddard_stark.id, 'x' => 0, 'y' => 0 },
            { 'id' => "character-#{jon_snow.id}", 'character_id' => jon_snow.id, 'x' => -240, 'y' => 220 },
            { 'id' => "character-#{sansa_stark.id}", 'character_id' => sansa_stark.id, 'x' => 0, 'y' => 220 },
            { 'id' => "character-#{arya_stark.id}", 'character_id' => arya_stark.id, 'x' => 240, 'y' => 220 }
          ],
          'edges' => context.fetch(:stark_parent_relations).map do |relation|
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
