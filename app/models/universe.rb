class Universe < ApplicationRecord
  include AttachableImages

  belongs_to :user

  has_many :worlds, dependent: :destroy
  has_many :characters, dependent: :destroy
  has_many :families, dependent: :destroy
  has_many :factions, dependent: :destroy
  has_many :family_trees, dependent: :destroy

  scope :publicly_visible, -> { where(public: true) }
  scope :owned_by, ->(user) { where(user: user) }
  scope :visible_to, ->(user) { where(user: user).or(publicly_visible) }

  validates :name, presence: true
end
