class CharacterBlueprint < Blueprinter::Base
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

  field :relations do |character|
    RelationBlueprint.render_as_hash(character.relations)
  end

  field :universe do |character, options|
    UniverseBlueprint.render_as_hash(character.universe, current_user: options[:current_user])
  end

  field :world do |character, options|
    character.world.present? ? WorldBlueprint.render_as_hash(character.world, current_user: options[:current_user]) : nil
  end

  field :families do |character, options|
    FamilyBlueprint.render_as_hash(
      CharacterBlueprint.visible_scope(character.families, Family, options[:current_user]),
      current_user: options[:current_user]
    )
  end

  field :related_families do |character, options|
    CharacterBlueprint.visible_scope(character.families, Family, options[:current_user]).map do |family|
      {
        family: FamilyBlueprint.render_as_hash(family, current_user: options[:current_user]),
        family_tree: family.family_tree.present? ? FamilyTreeBlueprint.render_as_hash(family.family_tree, current_user: options[:current_user]) : nil
      }
    end
  end

  field :factions do |character, options|
    FactionBlueprint.render_as_hash(
      CharacterBlueprint.visible_scope(character.factions, Faction, options[:current_user]),
      current_user: options[:current_user]
    )
  end

  field :family_trees do |character, options|
    FamilyTreeBlueprint.render_as_hash(
      CharacterBlueprint.visible_scope(character.family_trees, FamilyTree, options[:current_user]),
      current_user: options[:current_user]
    )
  end

  def self.visible_scope(scope, model, current_user)
    return model.none if current_user.blank?
    return scope if current_user&.admin?

    model.visible_to(current_user).where(id: scope.select(:id))
  end
end
