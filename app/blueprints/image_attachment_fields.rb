module ImageAttachmentFields
  extend ActiveSupport::Concern

  included do
    field :portrait_image do |resource|
      ImageAttachmentFields.attachment_payload(resource.portrait_image)
    end

    field :cover_image do |resource|
      ImageAttachmentFields.attachment_payload(resource.cover_image)
    end

    field :misc_images do |resource|
      resource.misc_images.attachments.map { |attachment| ImageAttachmentFields.attachment_payload(attachment) }
    end
  end

  def self.attachment_payload(attachment)
    return if attachment.blank?
    return if attachment.respond_to?(:attached?) && !attachment.attached?

    blob = attachment.blob

    {
      filename: blob.filename.to_s,
      content_type: blob.content_type,
      byte_size: blob.byte_size,
      url: Rails.application.routes.url_helpers.rails_blob_path(attachment, only_path: true)
    }
  end
end
