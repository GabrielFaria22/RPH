module ImageAttachmentFields
  extend ActiveSupport::Concern

  included do
    field :portrait_image do |resource|
      ImageAttachmentFields.attachment_payload(resource.portrait_image, resource.portrait_image_description)
    end

    field :cover_image do |resource|
      ImageAttachmentFields.attachment_payload(resource.cover_image, resource.cover_image_description)
    end

    field :banner_image do |resource|
      ImageAttachmentFields.attachment_payload(resource.banner_image, resource.banner_image_description)
    end

    field :crest_image do |resource|
      ImageAttachmentFields.attachment_payload(resource.crest_image, resource.crest_image_description)
    end

    field :misc_images do |resource|
      resource.misc_images.attachments.map do |attachment|
        ImageAttachmentFields.attachment_payload(attachment, resource.misc_images_description)
      end
    end
  end

  def self.attachment_payload(attachment, description = nil)
    return if attachment.blank?
    return if attachment.respond_to?(:attached?) && !attachment.attached?

    blob = attachment.blob

    {
      filename: blob.filename.to_s,
      content_type: blob.content_type,
      byte_size: blob.byte_size,
      description: description,
      url: Rails.application.routes.url_helpers.rails_blob_path(attachment, only_path: true)
    }
  end
end
