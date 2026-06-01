# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Location, type: :model do
  it 'requires a name' do
    location = build(:location, name: nil)

    expect(location).not_to be_valid
    expect(location.errors[:name]).to include("can't be blank")
  end

  it 'requires either a universe or world' do
    location = build(:location, universe: nil, world: nil)

    expect(location).not_to be_valid
    expect(location.errors[:base]).to include('Location must belong to a universe or world')
  end

  it 'allows a location inside another location in the same universe context' do
    universe = create(:universe)
    state = create(:location, universe: universe, location_type: 'state')
    city = build(:location, universe: universe, parent_location: state, location_type: 'city')

    expect(city).to be_valid
  end

  it 'does not allow a parent location from another universe context' do
    location = build(:location, parent_location: create(:location))

    expect(location).not_to be_valid
    expect(location.errors[:parent_location]).to include('must belong to the same universe or world context')
  end

  it 'does not allow a world from another universe when both are provided' do
    location = build(:location)
    location.world = create(:world)

    expect(location).not_to be_valid
    expect(location.errors[:world]).to include('must belong to the same universe')
  end
end
