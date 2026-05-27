class RelationBlueprint < Blueprinter::Base
  identifier :id

  fields :character_id, :related_character_id, :relation_type, :created_at, :updated_at
end
