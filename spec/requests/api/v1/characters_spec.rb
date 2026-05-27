# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Characters', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  it 'creates a character with optional fields and a large age' do
    universe = create(:universe, user: user)
    world = create(:world, universe: universe)

    post '/api/v1/characters', params: {
      character: {
        name: 'Aster',
        age: '1000000000000',
        universe_id: universe.id,
        world_id: world.id
      }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(universe.characters.find_by(name: 'Aster', age: '1000000000000')).to be_present
  end

  it 'does not expose another user character' do
    character = create(:character, universe: create(:universe, user: other_user))

    get "/api/v1/characters/#{character.id}", headers: headers

    expect(response).to have_http_status(:not_found)
  end
end
