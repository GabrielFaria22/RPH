module Seeds
  module Relations
    module_function

    def call(context)
      children = [
        context.fetch(:jon_snow),
        context.fetch(:sansa_stark),
        context.fetch(:arya_stark)
      ]

      parent_relations = children.map do |child|
        Helpers.upsert_character_relation(
          character: context.fetch(:eddard_stark),
          related_character: child,
          relation_type: 'parent'
        )
      end

      children.each do |child|
        Helpers.upsert_character_relation(
          character: child,
          related_character: context.fetch(:eddard_stark),
          relation_type: 'child'
        )
      end

      { stark_parent_relations: parent_relations }
    end
  end
end
