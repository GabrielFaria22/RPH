require 'rails_helper'

RSpec.describe 'Api::V1::Families', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  it 'creates a family and automatically creates its default family tree' do
    universe = create(:universe, user: user)
    leader = create(:character, universe: universe)

    post '/api/v1/families', params: {
      family: {
        name: 'House Aster',
        description: 'The first house.',
        public: true,
        universe_id: universe.id,
        leader_character_id: leader.id
      }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:created)
    family = universe.families.find_by!(name: 'House Aster')
    expect(family.family_tree).to be_present
    expect(family.family_tree.layout['nodes'].first['character_id']).to eq(leader.id)
  end

  it 'filters visible families with Ransack params' do
    own_family = create(:family, universe: create(:universe, user: user), name: 'House Aster', public: false)
    public_family = create(:family, universe: create(:universe, user: other_user), name: 'House Aster', public: true)
    create(:family, universe: create(:universe, user: user), name: 'House Ember', public: true)
    create(:family, universe: create(:universe, user: other_user), name: 'House Aster', public: false)

    get '/api/v1/families',
      params: { q: { name_cont: 'Aster' } },
      headers: headers

    response_ids = JSON.parse(response.body).map { |family| family['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_family.id, public_family.id)
  end

  it 'does not let users delete the last family from a faction' do
    universe = create(:universe, user: user)
    family = create(:family, universe: universe)
    faction = create(:faction, universe: universe)
    family.update!(faction: faction)

    delete "/api/v1/families/#{family.id}", headers: headers

    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)['errors']).to include('Faction must have at least one family')
  end
end
