class LocationBlueprint < Blueprinter::Base
  include ImageAttachmentFields

  identifier :id

  fields :name,
    :location_type,
    :brief_description,
    :full_description,
    :public,
    :universe_id,
    :world_id,
    :parent_location_id,
    :created_at,
    :updated_at

  field :owned_by_current_user do |location, options|
    options[:current_user].present? && location.universe_context&.user_id == options[:current_user].id
  end

  field :editable_by_current_user do |location, options|
    options[:current_user].present? && (options[:current_user].admin? || location.universe_context&.user_id == options[:current_user].id)
  end

  field :child_location_ids do |location|
    location.child_locations.map(&:id)
  end
end
