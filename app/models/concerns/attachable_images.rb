module AttachableImages
  extend ActiveSupport::Concern

  IMAGE_CONTENT_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  PORTRAIT_MAX_SIZE = 5.megabytes
  COVER_MAX_SIZE = 20.megabytes
  MISC_IMAGE_MAX_SIZE = 5.megabytes
  MISC_IMAGES_LIMIT = 8

  included do
    # Shared image slots for story resources. Portrait and cover are single
    # attachments, while misc_images is a small gallery.
    has_one_attached :portrait_image
    has_one_attached :cover_image
    has_many_attached :misc_images

    validate :portrait_image_is_valid
    validate :cover_image_is_valid
    validate :misc_images_are_valid
  end

  private

  def portrait_image_is_valid
    validate_single_image(:portrait_image, max_size: PORTRAIT_MAX_SIZE, orientation: :vertical)
  end

  def cover_image_is_valid
    validate_single_image(:cover_image, max_size: COVER_MAX_SIZE, orientation: :horizontal)
  end

  def misc_images_are_valid
    validate_image_count(:misc_images, limit: MISC_IMAGES_LIMIT)
    validate_many_images(:misc_images, max_size: MISC_IMAGE_MAX_SIZE)
  end

  def validate_single_image(name, max_size:, orientation:)
    attachment = public_send(name)
    return unless attachment.attached?

    validate_image_blob(name, attachment.blob, max_size: max_size, orientation: orientation)
  end

  def validate_many_images(name, max_size:)
    public_send(name).attachments.each do |attachment|
      validate_image_blob(name, attachment.blob, max_size: max_size)
    end
  end

  def validate_image_count(name, limit:)
    return unless public_send(name).attachments.size > limit

    errors.add(name, "can have at most #{limit} images")
  end

  def validate_image_blob(name, blob, max_size:, orientation: nil)
    errors.add(name, 'must be a JPEG, PNG, WebP, or GIF') unless IMAGE_CONTENT_TYPES.include?(blob.content_type)
    errors.add(name, "must be #{max_size / 1.megabyte}MB or smaller") if blob.byte_size > max_size
    validate_image_orientation(name, blob, orientation) if orientation
  end

  def validate_image_orientation(name, blob, orientation)
    width = blob.metadata['width']
    height = blob.metadata['height']
    return if width.blank? || height.blank?

    valid = orientation == :vertical ? height >= width : width >= height
    errors.add(name, "must be #{orientation == :vertical ? 'vertically' : 'horizontally'} oriented") unless valid
  end
end
