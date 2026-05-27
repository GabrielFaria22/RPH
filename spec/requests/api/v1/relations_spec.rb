# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Relations', type: :request do
  let(:user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  it 'creates a relation between two current user characters' do
    universe = create(:universe, user: user)
    character = create(:character, universe: universe)
    related_character = create(:character, universe: universe)

    post '/api/v1/relations', params: {
      relation: {
        character_id: character.id,
        related_character_id: related_character.id,
        relation_type: 'friend'
      }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(character.relations.find_by(related_character: related_character, relation_type: 'friend')).to be_present
  end
end
