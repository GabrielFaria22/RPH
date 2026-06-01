class World < ApplicationRecord
  include AttachableImages

  belongs_to :universe

  has_many :characters, dependent: :nullify
  has_many :locations, dependent: :destroy

  scope :publicly_visible, -> { where(public: true) }
  scope :owned_by, ->(user) { joins(:universe).where(universes: { user_id: user.id }) }
  scope :visible_to, ->(user) { left_joins(:universe).where('worlds.public = ? OR universes.user_id = ?', true, user.id) }

  validates :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      id
      name
      public
      universe_id
      updated_at
    ]
  end
end
