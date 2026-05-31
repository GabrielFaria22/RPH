class Relation < ApplicationRecord
  self.table_name = 'relation'

  TYPES = {
    parent: 'parent',
    child: 'child',
    sibling: 'sibling',
    grandparent: 'grandparent',
    grandchild: 'grandchild',
    ancestor: 'ancestor',
    descendant: 'descendant',
    spouse: 'spouse',
    partner: 'partner',
    lover: 'lover',
    fiance: 'fiance',
    ex_partner: 'ex_partner',
    friend: 'friend',
    best_friend: 'best_friend',
    acquaintance: 'acquaintance',
    ally: 'ally',
    enemy: 'enemy',
    rival: 'rival',
    mentor: 'mentor',
    student: 'student',
    guardian: 'guardian',
    ward: 'ward',
    adoptive_parent: 'adoptive_parent',
    adoptive_child: 'adoptive_child',
    step_parent: 'step_parent',
    step_child: 'step_child',
    uncle_aunt: 'uncle_aunt',
    nephew_niece: 'nephew_niece',
    cousin: 'cousin',
    coworker: 'coworker',
    leader: 'leader',
    follower: 'follower',
    master: 'master',
    servant: 'servant',
    creator: 'creator',
    creation: 'creation',
    alternate_version: 'alternate_version',
    other: 'other'
  }.freeze

  belongs_to :character
  belongs_to :related_character, class_name: 'Character'

  enum :relation_type, TYPES, prefix: :relation, validate: true

  validates :relation_type, presence: true
  validates :character_id,
    uniqueness: {
      scope: [:related_character_id, :relation_type],
      message: 'already has this relation'
    }
  validate :cannot_relate_character_to_itself
  validate :characters_belong_to_same_user

  private

  def cannot_relate_character_to_itself
    return if character_id.blank? || related_character_id.blank? || character_id != related_character_id

    errors.add(:related_character, 'must be different from character')
  end

  def characters_belong_to_same_user
    return if character.blank? || related_character.blank?
    return if character.universe.user_id == related_character.universe.user_id

    errors.add(:related_character, 'must belong to the same user')
  end
end
