class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  ADMIN_EMAILS = %w[gabrielfca222@gmail.com].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  before_validation :assign_admin_profile_type, if: :admin_email?

  has_many :people, dependent: :destroy
  has_many :universes, dependent: :destroy
  has_many :worlds, through: :universes
  has_many :characters, through: :universes
  has_many :families, through: :universes
  has_many :factions, through: :universes
  has_many :family_trees, through: :universes

  enum :profile_type, {
    regular: 'regular',
    admin: 'admin'
  }, validate: true

  def locations
    Location.owned_by(self)
  end

  private

  def admin_email?
    ADMIN_EMAILS.include?(email.to_s.downcase)
  end

  def assign_admin_profile_type
    self.profile_type = 'admin'
  end
end
