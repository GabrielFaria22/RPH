class UniverseBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description, :created_at, :updated_at
end
