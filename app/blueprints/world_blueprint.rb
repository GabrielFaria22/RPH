class WorldBlueprint < Blueprinter::Base
  include ImageAttachmentFields

  identifier :id

  fields :name, :description, :public, :universe_id, :created_at, :updated_at

  field :owned_by_current_user do |world, options|
    options[:current_user].present? && world.universe.user_id == options[:current_user].id
  end

  field :editable_by_current_user do |world, options|
    options[:current_user].present? && (options[:current_user].admin? || world.universe.user_id == options[:current_user].id)
  end
end
