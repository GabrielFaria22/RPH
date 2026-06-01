class Location < ApplicationRecord
  include AttachableImages

  belongs_to :universe, optional: true
  belongs_to :world, optional: true
  belongs_to :parent_location, class_name: 'Location', optional: true

  has_many :child_locations,
    class_name: 'Location',
    foreign_key: :parent_location_id,
    dependent: :nullify,
    inverse_of: :parent_location

  scope :publicly_visible, -> { where(public: true) }
  scope :owned_by, ->(user) {
    left_joins(:universe, world: :universe)
      .where('universes.user_id = ? OR universes_worlds.user_id = ?', user.id, user.id)
  }
  scope :visible_to, ->(user) {
    left_joins(:universe, world: :universe)
      .where('locations.public = ? OR universes.user_id = ? OR universes_worlds.user_id = ?', true, user.id, user.id)
  }

  validates :name, presence: true
  validate :belongs_to_universe_or_world
  validate :world_belongs_to_universe
  validate :parent_location_is_not_self
  validate :parent_location_belongs_to_same_universe_context

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      id
      location_type
      name
      parent_location_id
      public
      universe_id
      updated_at
      world_id
    ]
  end

  def universe_context
    universe || world&.universe
  end

  private

  def belongs_to_universe_or_world
    return if universe.present? || world.present?

    errors.add(:base, 'Location must belong to a universe or world')
  end

  def world_belongs_to_universe
    return if universe.blank? || world.blank? || world.universe_id == universe_id

    errors.add(:world, 'must belong to the same universe')
  end

  def parent_location_is_not_self
    return if parent_location_id.blank? || id.blank? || parent_location_id != id

    errors.add(:parent_location, 'must be different from location')
  end

  def parent_location_belongs_to_same_universe_context
    return if parent_location.blank? || universe_context.blank? || parent_location.universe_context == universe_context

    errors.add(:parent_location, 'must belong to the same universe or world context')
  end
end
