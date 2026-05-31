require 'rails_helper'

RSpec.describe 'Api::V1::FamilyRelations', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  it 'creates a relation between two current user families' do
    universe = create(:universe, user: user)
    family = create(:family, universe: universe)
    related_family = create(:family, universe: universe)

    post '/api/v1/family_relations', params: {
      family_relation: {
        family_id: family.id,
        related_family_id: related_family.id,
        relation_type: 'feud'
      }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:created)
    expect(family.family_relations.find_by(related_family: related_family, relation_type: 'feud')).to be_present
  end

  it 'lets users update their own family relation' do
    universe = create(:universe, user: user)
    family = create(:family, universe: universe)
    related_family = create(:family, universe: universe)
    relation = create(:family_relation, family: family, related_family: related_family, relation_type: 'friendship')

    patch "/api/v1/family_relations/#{relation.id}", params: {
      family_relation: { relation_type: 'rivalry' }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:ok)
    expect(relation.reload.relation_type).to eq('rivalry')
  end

  it 'does not let users create a relation with another user family' do
    family = create(:family, universe: create(:universe, user: user))
    other_family = create(:family, universe: create(:universe, user: other_user))

    post '/api/v1/family_relations', params: {
      family_relation: {
        family_id: family.id,
        related_family_id: other_family.id,
        relation_type: 'neutral'
      }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:not_found)
  end
end
