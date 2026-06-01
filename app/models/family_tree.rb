class FamilyTree < ApplicationRecord
  include AttachableImages

  belongs_to :universe
  belongs_to :family, optional: true

  scope :publicly_visible, -> { where(public: true) }
  scope :owned_by, ->(user) { joins(:universe).where(universes: { user_id: user.id }) }
  scope :visible_to, ->(user) { left_joins(:universe).where('family_trees.public = ? OR universes.user_id = ?', true, user.id) }

  validates :name, presence: true
  validate :layout_must_be_an_object
  validate :family_belongs_to_universe

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      family_id
      id
      name
      public
      universe_id
      updated_at
    ]
  end

  private

  def layout_must_be_an_object
    return if layout.is_a?(Hash)

    errors.add(:layout, 'must be an object')
  end

  def family_belongs_to_universe
    return if family.blank? || universe.blank? || family.universe_id == universe_id

    errors.add(:family, 'must belong to the same universe')
  end
end
