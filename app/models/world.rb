class World < ApplicationRecord
  belongs_to :universe

  has_many :characters, dependent: :nullify

  validates :name, presence: true
end
