# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageAttachmentFields do
  it 'serializes single and many image attachments' do
    universe = create(:universe)
    universe.update!(
      portrait_image_description: 'Portrait caption',
      banner_image_description: 'Banner caption',
      misc_images_description: 'Gallery caption'
    )
    universe.portrait_image.attach(
      io: StringIO.new('portrait'),
      filename: 'portrait.png',
      content_type: 'image/png'
    )
    universe.banner_image.attach(
      io: StringIO.new('banner'),
      filename: 'banner.png',
      content_type: 'image/png'
    )
    universe.misc_images.attach(
      io: StringIO.new('misc'),
      filename: 'misc.png',
      content_type: 'image/png'
    )

    payload = UniverseBlueprint.render_as_hash(universe)

    expect(payload[:portrait_image]).to include(filename: 'portrait.png', content_type: 'image/png', description: 'Portrait caption')
    expect(payload[:banner_image]).to include(filename: 'banner.png', content_type: 'image/png', description: 'Banner caption')
    expect(payload[:misc_images]).to contain_exactly(include(filename: 'misc.png', content_type: 'image/png', description: 'Gallery caption'))
  end
end
