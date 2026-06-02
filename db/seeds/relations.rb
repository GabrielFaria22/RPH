module Seeds
  module Relations
    module_function

    def call(context)
      eddard = context.fetch(:eddard_stark)
      catelyn = context.fetch(:catelyn_stark)
      jon = context.fetch(:jon_snow)

      trueborn_children = [
        context.fetch(:robb_stark),
        context.fetch(:sansa_stark),
        context.fetch(:arya_stark)
      ]

      stark_parent_relations = trueborn_children.flat_map do |child|
        [
          Helpers.upsert_character_relation(
            character: eddard,
            related_character: child,
            relation_type: 'parent'
          ),
          Helpers.upsert_character_relation(
            character: catelyn,
            related_character: child,
            relation_type: 'parent'
          )
        ]
      end

      acknowledged_parent_relation = Helpers.upsert_character_relation(
        character: eddard,
        related_character: jon,
        relation_type: 'parent'
      )

      spouse_relations = [
        Helpers.upsert_character_relation(
          character: eddard,
          related_character: catelyn,
          relation_type: 'spouse'
        ),
        Helpers.upsert_character_relation(
          character: catelyn,
          related_character: eddard,
          relation_type: 'spouse'
        )
      ]

      trueborn_children.each do |child|
        Helpers.upsert_character_relation(
          character: child,
          related_character: eddard,
          relation_type: 'child'
        )
        Helpers.upsert_character_relation(
          character: child,
          related_character: catelyn,
          relation_type: 'child'
        )
      end

      Helpers.upsert_character_relation(
        character: jon,
        related_character: eddard,
        relation_type: 'child'
      )

      Helpers.upsert_character_relation(
        character: catelyn,
        related_character: jon,
        relation_type: 'step_parent'
      )

      Helpers.upsert_character_relation(
        character: jon,
        related_character: catelyn,
        relation_type: 'step_child'
      )

      trueborn_children.combination(2).each do |first, second|
        Helpers.upsert_character_relation(
          character: first,
          related_character: second,
          relation_type: 'sibling'
        )
        Helpers.upsert_character_relation(
          character: second,
          related_character: first,
          relation_type: 'sibling'
        )
      end

      trueborn_children.each do |child|
        Helpers.upsert_character_relation(
          character: jon,
          related_character: child,
          relation_type: 'sibling'
        )
        Helpers.upsert_character_relation(
          character: child,
          related_character: jon,
          relation_type: 'sibling'
        )
      end

      {
        stark_parent_relations: stark_parent_relations,
        stark_acknowledged_parent_relation: acknowledged_parent_relation,
        stark_spouse_relations: spouse_relations
      }
    end
  end
end
