class World < ApplicationRecord
  include AttachableImages

  belongs_to :universe

  has_many :characters, dependent: :nullify

  scope :publicly_visible, -> { where(public: true) }
  scope :owned_by, ->(user) { joins(:universe).where(universes: { user_id: user.id }) }
  scope :visible_to, ->(user) { left_joins(:universe).where('worlds.public = ? OR universes.user_id = ?', true, user.id) }

  validates :name, presence: true
end
