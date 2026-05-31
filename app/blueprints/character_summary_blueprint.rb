class CharacterSummaryBlueprint < Blueprinter::Base
  include ImageAttachmentFields

  identifier :id

  fields :name,
    :full_name,
    :nickname,
    :age,
    :appearance,
    :occupation,
    :description,
    :story,
    :public,
    :universe_id,
    :world_id,
    :family_id,
    :faction_id,
    :created_at,
    :updated_at

  field :owned_by_current_user do |character, options|
    options[:current_user].present? && character.universe.user_id == options[:current_user].id
  end

  field :editable_by_current_user do |character, options|
    options[:current_user].present? && (options[:current_user].admin? || character.universe.user_id == options[:current_user].id)
  end
end
