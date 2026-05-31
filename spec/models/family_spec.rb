require 'rails_helper'

RSpec.describe Family, type: :model do
  it 'creates a default family tree with only the leader in the layout' do
    universe = create(:universe)
    leader = create(:character, universe: universe)

    family = create(:family, name: 'House Aster', universe: universe, leader_character: leader)

    expect(family.family_tree).to be_present
    expect(family.family_tree.name).to eq('House Aster Family Tree')
    expect(family.family_tree.layout['nodes']).to contain_exactly(
      include('id' => "character-#{leader.id}", 'character_id' => leader.id)
    )
    expect(family.family_tree.layout['edges']).to eq([])
  end

  it 'requires the leader to belong to the same universe' do
    family = build(:family, leader_character: create(:character))

    expect(family).not_to be_valid
    expect(family.errors[:leader_character]).to include('must belong to the same universe')
  end
end
