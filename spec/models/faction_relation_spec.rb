require 'rails_helper'

RSpec.describe FactionRelation, type: :model do
  it 'connects one faction to another faction with a relation type' do
    faction = create(:faction)
    related_faction = create(:faction, universe: faction.universe)

    relation = build(:faction_relation, faction: faction, related_faction: related_faction, relation_type: :enemy)

    expect(relation).to be_valid
  end

  it 'does not allow a faction to relate to itself' do
    faction = create(:faction)

    relation = build(:faction_relation, faction: faction, related_faction: faction)

    expect(relation).not_to be_valid
    expect(relation.errors[:related_faction]).to include('must be different from faction')
  end

  it 'does not allow relations across universes' do
    relation = build(:faction_relation, related_faction: create(:faction))

    expect(relation).not_to be_valid
    expect(relation.errors[:related_faction]).to include('must belong to the same universe')
  end
end
