require 'rails_helper'

RSpec.describe 'Api::V1::Factions', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
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

  it 'filters and sorts visible factions with Ransack params' do
    later_faction = create(:faction, universe: create(:universe, user: user), name: 'Zephyr Court', public: true)
    earlier_faction = create(:faction, universe: create(:universe, user: other_user), name: 'Aurora Court', public: true)
    create(:faction, universe: create(:universe, user: user), name: 'Ashen Guild', public: true)
    create(:faction, universe: create(:universe, user: other_user), name: 'Hidden Court', public: false)

    get '/api/v1/factions',
      params: { q: { name_cont: 'Court', public_eq: true, s: 'name desc' } },
      headers: headers

    response_ids = JSON.parse(response.body).map { |faction| faction['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to eq([later_faction.id, earlier_faction.id])
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
