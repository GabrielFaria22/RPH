class Universe < ApplicationRecord
  belongs_to :user

  has_many :worlds, dependent: :destroy
  has_many :characters, dependent: :destroy

  validates :name, presence: true
end
