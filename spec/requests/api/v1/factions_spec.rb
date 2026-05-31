require 'rails_helper'

RSpec.describe 'Api::V1::Factions', type: :request do
  let(:user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  it 'creates a faction with a leader and at least one family' do
    universe = create(:universe, user: user)
    leader = create(:character, universe: universe)
    family = create(:family, universe: universe)

    post '/api/v1/factions', params: {
      faction: {
        name: 'Northreach Court',
        description: 'The ruling faction.',
        public: true,
        universe_id: universe.id,
        leader_character_id: leader.id,
        family_ids: [family.id]
      }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:created)
    faction = universe.factions.find_by!(name: 'Northreach Court')
    expect(faction.families).to contain_exactly(family)
  end

  it 'rejects factions without families' do
    universe = create(:universe, user: user)
    leader = create(:character, universe: universe)

    post '/api/v1/factions', params: {
      faction: {
        name: 'Empty Court',
        universe_id: universe.id,
        leader_character_id: leader.id,
        family_ids: []
      }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)['errors']).to include('Faction must have at least one family')
  end
end
