class UniverseBlueprint < Blueprinter::Base
  include ImageAttachmentFields

  identifier :id

  fields :name, :description, :public, :created_at, :updated_at

  field :genre do |universe|
    Universe.genres[universe.genre]
  end

  field :owned_by_current_user do |universe, options|
    options[:current_user].present? && universe.user_id == options[:current_user].id
  end

  field :editable_by_current_user do |universe, options|
    options[:current_user].present? && (options[:current_user].admin? || universe.user_id == options[:current_user].id)
  end
end
