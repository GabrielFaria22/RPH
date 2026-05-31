class FamilyRelationBlueprint < Blueprinter::Base
  identifier :id

  fields :family_id, :related_family_id, :relation_type, :created_at, :updated_at
end
