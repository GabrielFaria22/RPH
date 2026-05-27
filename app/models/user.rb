class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :people, dependent: :destroy
  has_many :universes, dependent: :destroy
  has_many :worlds, through: :universes
  has_many :characters, through: :universes
end
