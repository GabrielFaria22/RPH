class Faction < ApplicationRecord
  belongs_to :universe
  belongs_to :leader_character, class_name: 'Character'

  has_many :families, dependent: :nullify
  has_many :faction_relations, dependent: :destroy
  has_many :related_factions, through: :faction_relations
  has_many :inverse_faction_relations,
    class_name: 'FactionRelation',
    foreign_key: :related_faction_id,
    dependent: :destroy,
    inverse_of: :related_faction
  has_many :related_by_factions, through: :inverse_faction_relations, source: :faction

  scope :publicly_visible, -> { where(public: true) }
  scope :owned_by, ->(user) { joins(:universe).where(universes: { user_id: user.id }) }
  scope :visible_to, ->(user) { left_joins(:universe).where('factions.public = ? OR universes.user_id = ?', true, user.id) }

  validates :name, presence: true
  validate :leader_character_belongs_to_universe

  private

  def leader_character_belongs_to_universe
    return if leader_character.blank? || universe.blank? || leader_character.universe_id == universe_id

    errors.add(:leader_character, 'must belong to the same universe')
  end
end
