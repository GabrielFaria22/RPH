# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageAttachmentFields do
  it 'serializes single and many image attachments' do
    universe = create(:universe)
    universe.portrait_image.attach(
      io: StringIO.new('portrait'),
      filename: 'portrait.png',
      content_type: 'image/png'
    )
    universe.misc_images.attach(
      io: StringIO.new('misc'),
      filename: 'misc.png',
      content_type: 'image/png'
    )

    payload = UniverseBlueprint.render_as_hash(universe)

    expect(payload[:portrait_image]).to include(filename: 'portrait.png', content_type: 'image/png')
    expect(payload[:misc_images]).to contain_exactly(include(filename: 'misc.png', content_type: 'image/png'))
  end
end
