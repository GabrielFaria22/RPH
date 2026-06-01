class Universe < ApplicationRecord
  include AttachableImages

  belongs_to :user

  has_many :worlds, dependent: :destroy
  has_many :characters, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :families, dependent: :destroy
  has_many :factions, dependent: :destroy
  has_many :family_trees, dependent: :destroy

  scope :publicly_visible, -> { where(public: true) }
  scope :owned_by, ->(user) { where(user: user) }
  scope :visible_to, ->(user) { where(user: user).or(publicly_visible) }

  enum :genre, {
    sci_fi: 'sci-fi',
    fantasy: 'fantasy',
    historical_fantasy: 'historical fantasy',
    historical: 'historical',
    horror: 'horror',
    mystery: 'mystery',
    romance: 'romance',
    western: 'western',
    superhero: 'superhero',
    dystopian: 'dystopian',
    post_apocalyptic: 'post-apocalyptic',
    steampunk: 'steampunk',
    cyberpunk: 'cyberpunk',
    urban_fantasy: 'urban fantasy',
    alternate_history: 'alternate history',
    space_opera: 'space opera',
    supernatural: 'supernatural',
    contemporary: 'contemporary',
    mythology: 'mythology',
    fairy_tale: 'fairy tale',
    crime: 'crime',
    thriller: 'thriller',
    other: 'other'
  }, prefix: :genre, validate: true

  validates :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      genre
      id
      name
      public
      updated_at
      user_id
    ]
  end
end
