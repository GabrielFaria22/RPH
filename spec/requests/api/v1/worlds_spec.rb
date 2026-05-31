# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Worlds', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:admin) { create(:user, :admin) }
  let(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }
  let(:admin_headers) { { 'Authorization' => "Bearer #{admin_token}" } }

  it 'creates a world inside one of the current user universes' do
    universe = create(:universe, user: user)

    post '/api/v1/worlds', params: {
      world: { name: 'Earth', description: 'Home world', universe_id: universe.id, public: true }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(universe.worlds.find_by(name: 'Earth', public: true)).to be_present
  end

  it 'lists current user worlds and public worlds by default' do
    own_world = create(:world, universe: create(:universe, user: user))
    public_world = create(:world, universe: create(:universe, user: other_user), public: true)
    create(:world, universe: create(:universe, user: other_user), public: false)

    get '/api/v1/worlds', headers: headers

    response_ids = JSON.parse(response.body).map { |world| world['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_world.id, public_world.id)
  end

  it 'lists only current user worlds from the mine endpoint' do
    own_world = create(:world, universe: create(:universe, user: user))
    create(:world, universe: create(:universe, user: other_user), public: true)

    get '/api/v1/worlds/mine', headers: headers

    response_ids = JSON.parse(response.body).map { |world| world['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_world.id)
  end

  it 'searches visible worlds by default' do
    own_world = create(:world, universe: create(:universe, user: user), name: 'Crystal Earth')
    public_world = create(:world, universe: create(:universe, user: other_user), name: 'Crystal Earth', public: true)
    create(:world, universe: create(:universe, user: other_user), name: 'Crystal Earth', public: false)

    get '/api/v1/worlds', params: { q: 'Crystal' }, headers: headers

    response_ids = JSON.parse(response.body).map { |world| world['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_world.id, public_world.id)
  end

  it 'searches only current user worlds from the mine endpoint' do
    own_world = create(:world, universe: create(:universe, user: user), name: 'Crystal Earth')
    create(:world, universe: create(:universe, user: other_user), name: 'Crystal Earth', public: true)

    get '/api/v1/worlds/mine', params: { q: 'Crystal' }, headers: headers

    response_ids = JSON.parse(response.body).map { |world| world['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_world.id)
  end

  it 'does not expose another user world' do
    world = create(:world, universe: create(:universe, user: other_user))

    get "/api/v1/worlds/#{world.id}", headers: headers

    expect(response).to have_http_status(:not_found)
  end

  it 'can show another user public world' do
    world = create(:world, universe: create(:universe, user: other_user), public: true)

    get "/api/v1/worlds/#{world.id}", headers: headers

    expect(response).to have_http_status(:ok)
  end

  it 'does not let users update another user public world' do
    world = create(:world, universe: create(:universe, user: other_user), public: true)

    patch "/api/v1/worlds/#{world.id}", params: {
      world: { name: 'Hijacked' }
    }, headers: headers

    expect(response).to have_http_status(:forbidden)
    expect(world.reload.name).not_to eq('Hijacked')
  end

  it 'lets admins update another user private world' do
    world = create(:world, universe: create(:universe, user: other_user), public: false)

    patch "/api/v1/worlds/#{world.id}", params: {
      world: { name: 'Admin Updated World' }
    }, headers: admin_headers

    expect(response).to have_http_status(:ok)
    expect(world.reload.name).to eq('Admin Updated World')
  end

  it 'marks whether visible worlds are owned by the current user' do
    own_world = create(:world, universe: create(:universe, user: user))
    other_world = create(:world, universe: create(:universe, user: other_user), public: true)

    get '/api/v1/worlds', headers: headers

    response_by_id = JSON.parse(response.body).index_by { |world| world['id'] }
    expect(response_by_id[own_world.id]['owned_by_current_user']).to be(true)
    expect(response_by_id[other_world.id]['owned_by_current_user']).to be(false)
    expect(response_by_id[other_world.id]['editable_by_current_user']).to be(false)
  end

  it 'lets users update their own world' do
    universe = create(:universe, user: user)
    world = create(:world, universe: universe, public: false)

    patch "/api/v1/worlds/#{world.id}", params: {
      world: { name: 'Updated World', description: 'Updated notes', public: true, universe_id: universe.id }
    }, headers: headers

    expect(response).to have_http_status(:ok)
    expect(world.reload).to have_attributes(
      name: 'Updated World',
      description: 'Updated notes',
      public: true
    )
  end
end
