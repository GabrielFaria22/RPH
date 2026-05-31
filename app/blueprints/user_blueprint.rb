class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :email, :profile_type, :created_at
end
