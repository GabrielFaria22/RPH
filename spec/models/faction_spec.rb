require 'rails_helper'

RSpec.describe Faction, type: :model do
  it 'requires the leader to belong to the same universe' do
    faction = build(:faction, leader_character: create(:character))

    expect(faction).not_to be_valid
    expect(faction.errors[:leader_character]).to include('must belong to the same universe')
  end
end
