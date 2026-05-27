class WorldBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description, :universe_id, :created_at, :updated_at
end
