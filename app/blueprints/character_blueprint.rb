class CharacterBlueprint < Blueprinter::Base
  identifier :id

  fields :name,
    :full_name,
    :nickname,
    :age,
    :appearance,
    :occupation,
    :description,
    :story,
    :universe_id,
    :world_id,
    :created_at,
    :updated_at

  field :portrait_image do |character|
    CharacterBlueprint.attachment_payload(character.portrait_image)
  end

  field :cover_image do |character|
    CharacterBlueprint.attachment_payload(character.cover_image)
  end

  field :relations do |character|
    RelationBlueprint.render_as_hash(character.relations)
  end

  class << self
    def attachment_payload(attachment)
      return unless attachment.attached?

      {
        filename: attachment.filename.to_s,
        content_type: attachment.content_type,
        byte_size: attachment.byte_size,
        url: Rails.application.routes.url_helpers.rails_blob_path(attachment, only_path: true)
      }
    end
  end
end
