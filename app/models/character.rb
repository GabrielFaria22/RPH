class Character < ApplicationRecord
  include AttachableImages

  belongs_to :universe
  belongs_to :world, optional: true
  belongs_to :family, optional: true
  belongs_to :faction, optional: true

  has_many :relations, class_name: 'Relation', dependent: :destroy
  has_many :related_characters, through: :relations
  has_many :inverse_relations,
    class_name: 'Relation',
    foreign_key: :related_character_id,
    dependent: :destroy,
    inverse_of: :related_character
  has_many :related_by_characters, through: :inverse_relations, source: :character
  has_many :led_families, class_name: 'Family', foreign_key: :leader_character_id, dependent: :restrict_with_error
  has_many :led_factions, class_name: 'Faction', foreign_key: :leader_character_id, dependent: :restrict_with_error

  validates :name, presence: true
  scope :publicly_visible, -> { where(public: true) }
  scope :owned_by, ->(user) { joins(:universe).where(universes: { user_id: user.id }) }
  scope :visible_to, ->(user) { left_joins(:universe).where('characters.public = ? OR universes.user_id = ?', true, user.id) }

  validate :world_belongs_to_universe
  validate :family_belongs_to_universe
  validate :faction_belongs_to_universe

  def families
    return Family.none if id.blank?

    Family
      .left_joins(:family_tree)
      .where(universe_id: universe_id)
      .where(
        'families.id = :family_id OR families.leader_character_id = :character_id OR family_trees.layout @> :layout',
        family_id: family_id,
        character_id: id,
        layout: family_tree_node_lookup.to_json
      )
      .distinct
  end

  def factions
    return Faction.none if id.blank?

    Faction
      .where(universe_id: universe_id)
      .where(id: families.where.not(faction_id: nil).select(:faction_id))
      .or(Faction.where(universe_id: universe_id, id: faction_id))
      .or(Faction.where(universe_id: universe_id, leader_character_id: id))
      .distinct
  end

  def family_trees
    return FamilyTree.none if id.blank?

    FamilyTree
      .left_joins(:family)
      .where(universe_id: universe_id)
      .where(
        'family_trees.family_id = :family_id OR families.leader_character_id = :character_id OR family_trees.layout @> :layout',
        family_id: family_id,
        character_id: id,
        layout: family_tree_node_lookup.to_json
      )
      .distinct
  end

  private

  def family_tree_node_lookup
    { nodes: [{ character_id: id }] }
  end

  def world_belongs_to_universe
    return if world.blank? || universe.blank? || world.universe_id == universe_id

    errors.add(:world, 'must belong to the same universe')
  end

  def family_belongs_to_universe
    return if family.blank? || universe.blank? || family.universe_id == universe_id

    errors.add(:family, 'must belong to the same universe')
  end

  def faction_belongs_to_universe
    return if faction.blank? || universe.blank? || faction.universe_id == universe_id

    errors.add(:faction, 'must belong to the same universe')
  end
end
