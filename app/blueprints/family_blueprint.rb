class FamilyBlueprint < Blueprinter::Base
  include ImageAttachmentFields

  identifier :id

  fields :name, :description, :public, :universe_id, :leader_character_id, :faction_id, :created_at, :updated_at

  field :family_tree_id do |family|
    family.family_tree&.id
  end

  field :relations do |family|
    FamilyRelationBlueprint.render_as_hash(family.family_relations)
  end

  field :owned_by_current_user do |family, options|
    options[:current_user].present? && family.universe.user_id == options[:current_user].id
  end

  field :editable_by_current_user do |family, options|
    options[:current_user].present? && (options[:current_user].admin? || family.universe.user_id == options[:current_user].id)
  end
end
