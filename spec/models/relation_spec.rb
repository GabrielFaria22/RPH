# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relation, type: :model do
  it 'connects a character to another character with a relation type' do
    character = create(:character)
    related_character = create(:character, universe: character.universe)

    relation = build(:relation, character: character, related_character: related_character, relation_type: :friend)

    expect(relation).to be_valid
  end

  it 'does not allow a character to relate to itself' do
    character = create(:character)

    relation = build(:relation, character: character, related_character: character)

    expect(relation).not_to be_valid
    expect(relation.errors[:related_character]).to include('must be different from character')
  end

  it 'does not allow relations across users' do
    relation = build(:relation, related_character: create(:character))

    expect(relation).not_to be_valid
    expect(relation.errors[:related_character]).to include('must belong to the same user')
  end
end
