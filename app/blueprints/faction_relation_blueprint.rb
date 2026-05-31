class FactionRelationBlueprint < Blueprinter::Base
  identifier :id

  fields :faction_id, :related_faction_id, :relation_type, :created_at, :updated_at
end
