# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Character, type: :model do
  it 'requires only a name and universe from the character fields' do
    character = build(:character, full_name: nil, nickname: nil, age: nil, appearance: nil,
      occupation: nil, description: nil, story: nil)

    expect(character).to be_valid
  end

  it 'does not allow a world from another universe' do
    character = build(:character)
    character.world = create(:world)

    expect(character).not_to be_valid
    expect(character.errors[:world]).to include('must belong to the same universe')
  end

  it 'validates portrait image size' do
    character = build(:character)
    character.portrait_image.attach(
      io: StringIO.new('a' * (Character::PORTRAIT_MAX_SIZE + 1)),
      filename: 'portrait.png',
      content_type: 'image/png'
    )

    expect(character).not_to be_valid
    expect(character.errors[:portrait_image]).to include('must be 5MB or smaller')
  end

  it 'validates cover image size' do
    character = build(:character)
    character.cover_image.attach(
      io: StringIO.new('a' * (Character::COVER_MAX_SIZE + 1)),
      filename: 'cover.png',
      content_type: 'image/png'
    )

    expect(character).not_to be_valid
    expect(character.errors[:cover_image]).to include('must be 15MB or smaller')
  end
end
