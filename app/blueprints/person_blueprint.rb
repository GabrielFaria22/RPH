class PersonBlueprint < Blueprinter::Base
  identifier :id

  fields :first_name, :last_name, :email, :phone, :created_at, :updated_at
end