# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Worlds', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  it 'creates a world inside one of the current user universes' do
    universe = create(:universe, user: user)

    post '/api/v1/worlds', params: {
      world: { name: 'Earth', description: 'Home world', universe_id: universe.id }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(universe.worlds.find_by(name: 'Earth')).to be_present
  end

  it 'does not expose another user world' do
    world = create(:world, universe: create(:universe, user: other_user))

    get "/api/v1/worlds/#{world.id}", headers: headers

    expect(response).to have_http_status(:not_found)
  end
end
