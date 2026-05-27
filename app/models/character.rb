class Character < ApplicationRecord
  IMAGE_CONTENT_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  PORTRAIT_MAX_SIZE = 5.megabytes
  COVER_MAX_SIZE = 15.megabytes

  belongs_to :universe
  belongs_to :world, optional: true

  has_many :relations, class_name: 'Relation', dependent: :destroy
  has_many :related_characters, through: :relations
  has_many :inverse_relations,
    class_name: 'Relation',
    foreign_key: :related_character_id,
    dependent: :destroy,
    inverse_of: :related_character
  has_many :related_by_characters, through: :inverse_relations, source: :character

  has_one_attached :portrait_image
  has_one_attached :cover_image

  validates :name, presence: true
  validate :world_belongs_to_universe
  validate :portrait_image_is_valid
  validate :cover_image_is_valid

  private

  def world_belongs_to_universe
    return if world.blank? || universe.blank? || world.universe_id == universe_id

    errors.add(:world, 'must belong to the same universe')
  end

  def portrait_image_is_valid
    validate_image(:portrait_image, max_size: PORTRAIT_MAX_SIZE)
  end

  def cover_image_is_valid
    validate_image(:cover_image, max_size: COVER_MAX_SIZE)
  end

  def validate_image(name, max_size:)
    attachment = public_send(name)
    return unless attachment.attached?

    blob = attachment.blob
    errors.add(name, 'must be a JPEG, PNG, WebP, or GIF') unless IMAGE_CONTENT_TYPES.include?(blob.content_type)
    errors.add(name, "must be #{max_size / 1.megabyte}MB or smaller") if blob.byte_size > max_size
  end
end
