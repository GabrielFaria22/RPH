class FamilyRelation < ApplicationRecord
  TYPES = {
    friendship: 'friendship',
    alliance: 'alliance',
    marriage_alliance: 'marriage_alliance',
    trade_partner: 'trade_partner',
    patron: 'patron',
    client: 'client',
    protector: 'protector',
    protected_family: 'protected_family',
    parent_house: 'parent_house',
    branch_house: 'branch_house',
    cadet_branch: 'cadet_branch',
    blood_oath: 'blood_oath',
    truce: 'truce',
    neutral: 'neutral',
    rivalry: 'rivalry',
    feud: 'feud',
    enemy: 'enemy',
    war: 'war',
    estranged: 'estranged',
    former_allies: 'former_allies',
    other: 'other'
  }.freeze

  belongs_to :family
  belongs_to :related_family, class_name: 'Family'

  enum :relation_type, TYPES, prefix: :relation, validate: true

  validates :relation_type, presence: true
  validates :family_id,
    uniqueness: {
      scope: [:related_family_id, :relation_type],
      message: 'already has this relation'
    }
  validate :cannot_relate_family_to_itself
  validate :families_belong_to_same_universe

  private

  def cannot_relate_family_to_itself
    return if family_id.blank? || related_family_id.blank? || family_id != related_family_id

    errors.add(:related_family, 'must be different from family')
  end

  def families_belong_to_same_universe
    return if family.blank? || related_family.blank?
    return if family.universe_id == related_family.universe_id

    errors.add(:related_family, 'must belong to the same universe')
  end
end
