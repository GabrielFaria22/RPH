require 'rails_helper'

RSpec.describe 'Api::V1::FamilyTrees', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:admin) { create(:user, :admin) }
  let(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }
  let(:admin_headers) { { 'Authorization' => "Bearer #{admin_token}" } }

  it 'creates a family tree inside one of the current user universes' do
    universe = create(:universe, user: user)
    character = create(:character, universe: universe)

    post '/api/v1/family_trees', params: {
      family_tree: {
        name: 'House Aster',
        description: 'Main bloodline view',
        universe_id: universe.id,
        public: true,
        layout: {
          nodes: [{ id: "character-#{character.id}", character_id: character.id, x: 120, y: 80 }],
          edges: [],
          viewport: { x: 0, y: 0, zoom: 1 }
        }
      }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:created)
    expect(universe.family_trees.find_by(name: 'House Aster', public: true)).to be_present
    expect(JSON.parse(response.body)['layout']['nodes'].first['character_id']).to eq(character.id)
  end

  it 'lists current user family trees and public family trees by default' do
    own_family_tree = create(:family_tree, universe: create(:universe, user: user))
    public_family_tree = create(:family_tree, universe: create(:universe, user: other_user), public: true)
    create(:family_tree, universe: create(:universe, user: other_user), public: false)

    get '/api/v1/family_trees', headers: headers

    response_ids = JSON.parse(response.body).map { |family_tree| family_tree['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_family_tree.id, public_family_tree.id)
  end

  it 'lists only current user family trees from the mine endpoint' do
    own_family_tree = create(:family_tree, universe: create(:universe, user: user))
    create(:family_tree, universe: create(:universe, user: other_user), public: true)

    get '/api/v1/family_trees/mine', headers: headers

    response_ids = JSON.parse(response.body).map { |family_tree| family_tree['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_family_tree.id)
  end

  it 'filters and sorts visible family trees with Ransack params' do
    later_family_tree = create(:family_tree, universe: create(:universe, user: user), name: 'Zephyr Line', public: true)
    earlier_family_tree = create(:family_tree, universe: create(:universe, user: other_user), name: 'Aurora Line', public: true)
    create(:family_tree, universe: create(:universe, user: user), name: 'Ashen Branch', public: true)
    create(:family_tree, universe: create(:universe, user: other_user), name: 'Hidden Line', public: false)

    get '/api/v1/family_trees',
      params: { q: { name_cont: 'Line', public_eq: true, s: 'name desc' } },
      headers: headers

    response_ids = JSON.parse(response.body).map { |family_tree| family_tree['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to eq([later_family_tree.id, earlier_family_tree.id])
  end

  it 'does not expose another user private family tree' do
    family_tree = create(:family_tree, universe: create(:universe, user: other_user))

    get "/api/v1/family_trees/#{family_tree.id}", headers: headers

    expect(response).to have_http_status(:not_found)
  end

  it 'does not let users update another user public family tree' do
    family_tree = create(:family_tree, universe: create(:universe, user: other_user), public: true)

    patch "/api/v1/family_trees/#{family_tree.id}", params: {
      family_tree: { name: 'Hijacked' }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:forbidden)
    expect(family_tree.reload.name).not_to eq('Hijacked')
  end

  it 'lets admins update another user private family tree' do
    family_tree = create(:family_tree, universe: create(:universe, user: other_user), public: false)

    patch "/api/v1/family_trees/#{family_tree.id}", params: {
      family_tree: { name: 'Admin Updated Family Tree' }
    }, headers: admin_headers

    expect(response).to have_http_status(:ok)
    expect(family_tree.reload.name).to eq('Admin Updated Family Tree')
  end

  it 'lets users update their own family tree layout' do
    universe = create(:universe, user: user)
    family_tree = create(:family_tree, universe: universe)

    patch "/api/v1/family_trees/#{family_tree.id}", params: {
      family_tree: {
        name: 'Updated House Aster',
        layout: {
          nodes: [{ id: 'character-1', character_id: 1, x: 240, y: 120 }],
          edges: [{ id: 'relation-1', relation_id: 1 }],
          viewport: { x: 10, y: -5, zoom: 0.8 }
        }
      }
    }, headers: headers, as: :json

    expect(response).to have_http_status(:ok)
    expect(family_tree.reload).to have_attributes(name: 'Updated House Aster')
    expect(family_tree.layout['viewport']['zoom']).to eq(0.8)
  end
end
