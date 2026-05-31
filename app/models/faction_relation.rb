class FactionRelation < ApplicationRecord
  TYPES = {
    alliance: 'alliance',
    coalition: 'coalition',
    trade_partner: 'trade_partner',
    non_aggression_pact: 'non_aggression_pact',
    patron: 'patron',
    client: 'client',
    protectorate: 'protectorate',
    overlord: 'overlord',
    vassal: 'vassal',
    member: 'member',
    splinter_group: 'splinter_group',
    truce: 'truce',
    neutral: 'neutral',
    rivalry: 'rivalry',
    enemy: 'enemy',
    war: 'war',
    cold_war: 'cold_war',
    former_allies: 'former_allies',
    other: 'other'
  }.freeze

  belongs_to :faction
  belongs_to :related_faction, class_name: 'Faction'

  enum :relation_type, TYPES, prefix: :relation, validate: true

  validates :relation_type, presence: true
  validates :faction_id,
    uniqueness: {
      scope: [:related_faction_id, :relation_type],
      message: 'already has this relation'
    }
  validate :cannot_relate_faction_to_itself
  validate :factions_belong_to_same_universe

  private

  def cannot_relate_faction_to_itself
    return if faction_id.blank? || related_faction_id.blank? || faction_id != related_faction_id

    errors.add(:related_faction, 'must be different from faction')
  end

  def factions_belong_to_same_universe
    return if faction.blank? || related_faction.blank?
    return if faction.universe_id == related_faction.universe_id

    errors.add(:related_faction, 'must belong to the same universe')
  end
end
