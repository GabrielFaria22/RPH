# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Relations', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:admin) { create(:user, :admin) }
  let(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }
  let(:admin_headers) { { 'Authorization' => "Bearer #{admin_token}" } }

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

  it 'lets admins list all relations' do
    own_universe = create(:universe, user: user)
    own_relation = create(:relation,
      character: create(:character, universe: own_universe),
      related_character: create(:character, universe: own_universe))
    other_universe = create(:universe, user: other_user)
    other_relation = create(:relation,
      character: create(:character, universe: other_universe),
      related_character: create(:character, universe: other_universe))

    get '/api/v1/relations', headers: admin_headers

    response_ids = JSON.parse(response.body).map { |relation| relation['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to include(own_relation.id, other_relation.id)
  end

  it 'lets users update their own relation' do
    universe = create(:universe, user: user)
    character = create(:character, universe: universe)
    related_character = create(:character, universe: universe)
    relation = create(:relation, character: character, related_character: related_character, relation_type: 'friend')

    patch "/api/v1/relations/#{relation.id}", params: {
      relation: { relation_type: 'ally' }
    }, headers: headers

    expect(response).to have_http_status(:ok)
    expect(relation.reload.relation_type).to eq('ally')
  end

  it 'does not let users update another user relation' do
    universe = create(:universe, user: other_user)
    character = create(:character, universe: universe, public: true)
    related_character = create(:character, universe: universe, public: true)
    relation = create(:relation, character: character, related_character: related_character, relation_type: 'friend')

    patch "/api/v1/relations/#{relation.id}", params: {
      relation: { relation_type: 'ally' }
    }, headers: headers

    expect(response).to have_http_status(:not_found)
    expect(relation.reload.relation_type).to eq('friend')
  end

  it 'lets admins update another user relation' do
    universe = create(:universe, user: other_user)
    character = create(:character, universe: universe)
    related_character = create(:character, universe: universe)
    relation = create(:relation, character: character, related_character: related_character, relation_type: 'friend')

    patch "/api/v1/relations/#{relation.id}", params: {
      relation: { relation_type: 'ally' }
    }, headers: admin_headers

    expect(response).to have_http_status(:ok)
    expect(relation.reload.relation_type).to eq('ally')
  end
end
