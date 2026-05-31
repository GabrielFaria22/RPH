require 'rails_helper'

RSpec.describe 'Api::V1::FactionRelations', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  it 'creates a relation between two current user factions' do
    universe = create(:universe, user: user)
    faction = create(:faction, universe: universe)
    related_faction = create(:faction, universe: universe)

    post '/api/v1/faction_relations', params: {
      faction_relation: {
        faction_id: faction.id,
        related_faction_id: related_faction.id,
        relation_type: 'alliance'
      }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:created)
    expect(faction.faction_relations.find_by(related_faction: related_faction, relation_type: 'alliance')).to be_present
  end

  it 'lets users update their own faction relation' do
    universe = create(:universe, user: user)
    faction = create(:faction, universe: universe)
    related_faction = create(:faction, universe: universe)
    relation = create(:faction_relation, faction: faction, related_faction: related_faction, relation_type: 'alliance')

    patch "/api/v1/faction_relations/#{relation.id}", params: {
      faction_relation: { relation_type: 'enemy' }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:ok)
    expect(relation.reload.relation_type).to eq('enemy')
  end

  it 'does not let users create a relation with another user faction' do
    faction = create(:faction, universe: create(:universe, user: user))
    other_faction = create(:faction, universe: create(:universe, user: other_user))

    post '/api/v1/faction_relations', params: {
      faction_relation: {
        faction_id: faction.id,
        related_faction_id: other_faction.id,
        relation_type: 'neutral'
      }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:not_found)
  end
end
