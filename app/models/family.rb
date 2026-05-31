class Family < ApplicationRecord
  belongs_to :universe
  belongs_to :leader_character, class_name: 'Character'
  belongs_to :faction, optional: true

  has_one :family_tree, dependent: :destroy
  has_many :family_relations, dependent: :destroy
  has_many :related_families, through: :family_relations
  has_many :inverse_family_relations,
    class_name: 'FamilyRelation',
    foreign_key: :related_family_id,
    dependent: :destroy,
    inverse_of: :related_family
  has_many :related_by_families, through: :inverse_family_relations, source: :family

  after_create :create_default_family_tree

  scope :publicly_visible, -> { where(public: true) }
  scope :owned_by, ->(user) { joins(:universe).where(universes: { user_id: user.id }) }
  scope :visible_to, ->(user) { left_joins(:universe).where('families.public = ? OR universes.user_id = ?', true, user.id) }

  validates :name, presence: true
  validate :leader_character_belongs_to_universe
  validate :faction_belongs_to_universe

  private

  def create_default_family_tree
    create_family_tree!(
      name: "#{name} Family Tree",
      description: description,
      public: public,
      universe: universe,
      layout: default_family_tree_layout
    )
  end

  def default_family_tree_layout
    {
      'nodes' => [
        {
          'id' => "character-#{leader_character_id}",
          'character_id' => leader_character_id,
          'x' => 0,
          'y' => 0
        }
      ],
      'edges' => [],
      'viewport' => {
        'x' => 0,
        'y' => 0,
        'zoom' => 1
      }
    }
  end

  def leader_character_belongs_to_universe
    return if leader_character.blank? || universe.blank? || leader_character.universe_id == universe_id

    errors.add(:leader_character, 'must belong to the same universe')
  end

  def faction_belongs_to_universe
    return if faction.blank? || universe.blank? || faction.universe_id == universe_id

    errors.add(:faction, 'must belong to the same universe')
  end
end
