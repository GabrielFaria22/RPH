# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Characters', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:admin) { create(:user, :admin) }
  let(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }
  let(:admin_headers) { { 'Authorization' => "Bearer #{admin_token}" } }

  it 'creates a character with optional fields and a large age' do
    universe = create(:universe, user: user)
    world = create(:world, universe: universe)
    family_leader = create(:character, universe: universe)
    faction_leader = create(:character, universe: universe)
    faction = create(:faction, universe: universe, leader_character: faction_leader)
    family = create(:family, universe: universe, leader_character: family_leader, faction: faction)

    post '/api/v1/characters', params: {
      character: {
        name: 'Aster',
        age: '1000000000000',
        public: true,
        universe_id: universe.id,
        world_id: world.id,
        family_id: family.id,
        faction_id: faction.id
      }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(universe.characters.find_by(
      name: 'Aster',
      age: '1000000000000',
      public: true,
      family: family,
      faction: faction
    )).to be_present
  end

  it 'lists current user characters and public characters by default' do
    own_character = create(:character, universe: create(:universe, user: user))
    public_character = create(:character, universe: create(:universe, user: other_user), public: true)
    create(:character, universe: create(:universe, user: other_user), public: false)

    get '/api/v1/characters', headers: headers

    response_ids = JSON.parse(response.body).map { |character| character['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_character.id, public_character.id)
  end

  it 'lists only current user characters from the mine endpoint' do
    own_character = create(:character, universe: create(:universe, user: user))
    create(:character, universe: create(:universe, user: other_user), public: true)

    get '/api/v1/characters/mine', headers: headers

    response_ids = JSON.parse(response.body).map { |character| character['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_character.id)
  end

  it 'searches visible characters by default' do
    own_character = create(:character, universe: create(:universe, user: user), name: 'Aster Prime')
    public_character = create(:character, universe: create(:universe, user: other_user), name: 'Aster Prime', public: true)
    create(:character, universe: create(:universe, user: other_user), name: 'Aster Prime', public: false)

    get '/api/v1/characters', params: { q: 'Aster' }, headers: headers

    response_ids = JSON.parse(response.body).map { |character| character['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_character.id, public_character.id)
  end

  it 'searches only current user characters from the mine endpoint' do
    own_character = create(:character, universe: create(:universe, user: user), name: 'Aster Prime')
    create(:character, universe: create(:universe, user: other_user), name: 'Aster Prime', public: true)

    get '/api/v1/characters/mine', params: { q: 'Aster' }, headers: headers

    response_ids = JSON.parse(response.body).map { |character| character['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_character.id)
  end

  it 'filters and sorts visible characters with Ransack params' do
    create(:character, universe: create(:universe, user: user), name: 'Private Aster', public: false)
    later_character = create(:character, universe: create(:universe, user: user), name: 'Zephyr Aster', public: true)
    earlier_character = create(:character, universe: create(:universe, user: other_user), name: 'Aurora Aster', public: true)
    create(:character, universe: create(:universe, user: other_user), name: 'Hidden Aster', public: false)

    get '/api/v1/characters',
      params: { q: { name_cont: 'Aster', public_eq: true, s: 'name desc' } },
      headers: headers

    response_ids = JSON.parse(response.body).map { |character| character['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to eq([later_character.id, earlier_character.id])
  end

  it 'does not expose another user character' do
    character = create(:character, universe: create(:universe, user: other_user))

    get "/api/v1/characters/#{character.id}", headers: headers

    expect(response).to have_http_status(:not_found)
  end

  it 'can show another user public character' do
    character = create(:character, universe: create(:universe, user: other_user), public: true)

    get "/api/v1/characters/#{character.id}", headers: headers

    expect(response).to have_http_status(:ok)
  end

  it 'does not let users update another user public character' do
    character = create(:character, universe: create(:universe, user: other_user), public: true)

    patch "/api/v1/characters/#{character.id}", params: {
      character: { name: 'Hijacked' }
    }, headers: headers

    expect(response).to have_http_status(:forbidden)
    expect(character.reload.name).not_to eq('Hijacked')
  end

  it 'lets admins update another user private character' do
    character = create(:character, universe: create(:universe, user: other_user), public: false)

    patch "/api/v1/characters/#{character.id}", params: {
      character: { name: 'Admin Updated Character' }
    }, headers: admin_headers

    expect(response).to have_http_status(:ok)
    expect(character.reload.name).to eq('Admin Updated Character')
  end

  it 'marks whether visible characters are owned by the current user' do
    own_character = create(:character, universe: create(:universe, user: user))
    other_character = create(:character, universe: create(:universe, user: other_user), public: true)

    get '/api/v1/characters', headers: headers

    response_by_id = JSON.parse(response.body).index_by { |character| character['id'] }
    expect(response_by_id[own_character.id]['owned_by_current_user']).to be(true)
    expect(response_by_id[other_character.id]['owned_by_current_user']).to be(false)
    expect(response_by_id[other_character.id]['editable_by_current_user']).to be(false)
  end

  it 'uses a lightweight payload for character lists' do
    create(:character, universe: create(:universe, user: user))

    get '/api/v1/characters', headers: headers

    character = JSON.parse(response.body).first
    expect(response).to have_http_status(:ok)
    expect(character).to include('name', 'universe_id', 'world_id')
    expect(character).not_to include('relations', 'universe', 'world', 'families', 'related_families', 'factions', 'family_trees')
  end

  it 'shows related character sheet data' do
    universe = create(:universe, user: user, name: 'A World of Ice and Fire')
    world = create(:world, universe: universe, name: 'Planetos')
    eddard = create(:character, universe: universe, world: world, name: 'Eddard Stark')
    jon = create(:character, universe: universe, world: world, name: 'Jon Snow')
    faction = create(:faction, universe: universe, leader_character: eddard, name: 'The North')
    family = create(:family, universe: universe, leader_character: eddard, faction: faction, name: 'House Stark')

    relation = create(:relation, character: eddard, related_character: jon, relation_type: 'parent')
    family.family_tree.update!(
      layout: {
        nodes: [
          { id: "character-#{eddard.id}", character_id: eddard.id, x: 0, y: 0 },
          { id: "character-#{jon.id}", character_id: jon.id, x: 0, y: 200 }
        ],
        edges: [
          {
            id: "relation-#{relation.id}",
            relation_id: relation.id,
            source: "character-#{eddard.id}",
            target: "character-#{jon.id}",
            relation_type: 'parent'
          }
        ],
        viewport: { x: 0, y: 0, zoom: 1 }
      }
    )

    get "/api/v1/characters/#{jon.id}", headers: headers

    body = JSON.parse(response.body)
    expect(response).to have_http_status(:ok)
    expect(body['universe']['name']).to eq('A World of Ice and Fire')
    expect(body['world']['name']).to eq('Planetos')
    expect(body['families'].map { |related_family| related_family['name'] }).to include('House Stark')
    expect(body['related_families'].first['family']['name']).to eq('House Stark')
    expect(body['related_families'].first['family']['family_tree_id']).to eq(family.family_tree.id)
    expect(body['related_families'].first['family_tree']['id']).to eq(family.family_tree.id)
    expect(body['related_families'].first['family_tree']['layout']['nodes'].map { |node| node['character_id'] }).to include(jon.id)
    expect(body['factions'].map { |related_faction| related_faction['name'] }).to include('The North')
    expect(body['family_trees'].first['layout']['nodes'].map { |node| node['character_id'] }).to include(jon.id)
  end

  it 'lets users update their own character' do
    universe = create(:universe, user: user)
    world = create(:world, universe: universe)
    character = create(:character, universe: universe, world: world, public: false)

    patch "/api/v1/characters/#{character.id}", params: {
      character: { name: 'Updated Character', age: '1000002', public: true, universe_id: universe.id, world_id: world.id }
    }, headers: headers

    expect(response).to have_http_status(:ok)
    expect(character.reload).to have_attributes(
      name: 'Updated Character',
      age: '1000002',
      public: true
    )
  end

  it 'lets users assign and clear optional family and faction membership' do
    universe = create(:universe, user: user)
    character = create(:character, universe: universe)
    family_leader = create(:character, universe: universe)
    faction_leader = create(:character, universe: universe)
    faction = create(:faction, universe: universe, leader_character: faction_leader)
    family = create(:family, universe: universe, leader_character: family_leader, faction: faction)

    patch "/api/v1/characters/#{character.id}", params: {
      character: { family_id: family.id, faction_id: faction.id }
    }, headers: headers

    expect(response).to have_http_status(:ok)
    expect(character.reload).to have_attributes(family_id: family.id, faction_id: faction.id)

    patch "/api/v1/characters/#{character.id}", params: {
      character: { family_id: '', faction_id: '' }
    }, headers: headers

    expect(response).to have_http_status(:ok)
    expect(character.reload).to have_attributes(family_id: nil, faction_id: nil)
  end
end
