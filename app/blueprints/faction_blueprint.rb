class FactionBlueprint < Blueprinter::Base
  include ImageAttachmentFields

  identifier :id

  fields :name, :description, :public, :universe_id, :leader_character_id, :created_at, :updated_at

  field :family_ids do |faction|
    faction.families.pluck(:id)
  end

  field :relations do |faction|
    FactionRelationBlueprint.render_as_hash(faction.faction_relations)
  end

  field :owned_by_current_user do |faction, options|
    options[:current_user].present? && faction.universe.user_id == options[:current_user].id
  end

  field :editable_by_current_user do |faction, options|
    options[:current_user].present? && (options[:current_user].admin? || faction.universe.user_id == options[:current_user].id)
  end
end
