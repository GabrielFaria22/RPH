require 'rails_helper'

RSpec.describe FamilyTree, type: :model do
  it 'requires a name and universe' do
    family_tree = build(:family_tree, name: nil)

    expect(family_tree).not_to be_valid
    expect(family_tree.errors[:name]).to include("can't be blank")
  end

  it 'stores layout as a JSON object' do
    family_tree = build(:family_tree, layout: { 'nodes' => [{ 'id' => 'character-1', 'x' => 120, 'y' => 40 }] })

    expect(family_tree).to be_valid
  end

  it 'does not allow a non-object layout' do
    family_tree = build(:family_tree, layout: ['character-1'])

    expect(family_tree).not_to be_valid
    expect(family_tree.errors[:layout]).to include('must be an object')
  end
end
