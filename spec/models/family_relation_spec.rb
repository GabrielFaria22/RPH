require 'rails_helper'

RSpec.describe FamilyRelation, type: :model do
  it 'connects one family to another family with a relation type' do
    family = create(:family)
    related_family = create(:family, universe: family.universe)

    relation = build(:family_relation, family: family, related_family: related_family, relation_type: :feud)

    expect(relation).to be_valid
  end

  it 'does not allow a family to relate to itself' do
    family = create(:family)

    relation = build(:family_relation, family: family, related_family: family)

    expect(relation).not_to be_valid
    expect(relation.errors[:related_family]).to include('must be different from family')
  end

  it 'does not allow relations across universes' do
    relation = build(:family_relation, related_family: create(:family))

    expect(relation).not_to be_valid
    expect(relation.errors[:related_family]).to include('must belong to the same universe')
  end
end
