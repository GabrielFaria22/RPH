class FamilyTreeBlueprint < Blueprinter::Base
  include ImageAttachmentFields

  identifier :id

  fields :name, :description, :public, :layout, :universe_id, :family_id, :created_at, :updated_at

  field :owned_by_current_user do |family_tree, options|
    options[:current_user].present? && family_tree.universe.user_id == options[:current_user].id
  end

  field :editable_by_current_user do |family_tree, options|
    options[:current_user].present? && (options[:current_user].admin? || family_tree.universe.user_id == options[:current_user].id)
  end
end
