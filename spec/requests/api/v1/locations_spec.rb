# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Locations', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:admin) { create(:user, :admin) }
  let(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }
  let(:admin_headers) { { 'Authorization' => "Bearer #{admin_token}" } }

  it 'creates a location inside one of the current user universes' do
    universe = create(:universe, user: user)

    post '/api/v1/locations', params: {
      location: {
        name: 'Milky Way',
        location_type: 'galaxy',
        brief_description: 'A spiral galaxy.',
        full_description: 'The home galaxy for the main continuity.',
        universe_id: universe.id,
        public: true
      }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(universe.locations.find_by(name: 'Milky Way', location_type: 'galaxy', public: true)).to be_present
  end

  it 'creates a location inside one of the current user worlds' do
    world = create(:world, universe: create(:universe, user: user))

    post '/api/v1/locations', params: {
      location: { name: 'Old Town', location_type: 'neighborhood', world_id: world.id }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(world.locations.find_by(name: 'Old Town', location_type: 'neighborhood')).to be_present
  end

  it 'creates a nested location under another location' do
    universe = create(:universe, user: user)
    state = create(:location, universe: universe, location_type: 'state')

    post '/api/v1/locations', params: {
      location: { name: 'Capital City', location_type: 'city', universe_id: universe.id, parent_location_id: state.id }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(state.child_locations.find_by(name: 'Capital City')).to be_present
  end

  it 'lists current user locations and public locations by default' do
    own_location = create(:location, universe: create(:universe, user: user))
    public_location = create(:location, universe: create(:universe, user: other_user), public: true)
    create(:location, universe: create(:universe, user: other_user), public: false)

    get '/api/v1/locations', headers: headers

    response_ids = JSON.parse(response.body).map { |location| location['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_location.id, public_location.id)
  end

  it 'lists only current user locations from the mine endpoint' do
    own_location = create(:location, universe: create(:universe, user: user))
    create(:location, universe: create(:universe, user: other_user), public: true)

    get '/api/v1/locations/mine', headers: headers

    response_ids = JSON.parse(response.body).map { |location| location['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_location.id)
  end

  it 'searches visible locations by default' do
    own_location = create(:location, universe: create(:universe, user: user), name: 'Crystal City')
    public_location = create(:location, universe: create(:universe, user: other_user), name: 'Crystal City', public: true)
    create(:location, universe: create(:universe, user: other_user), name: 'Crystal City', public: false)

    get '/api/v1/locations', params: { q: 'Crystal' }, headers: headers

    response_ids = JSON.parse(response.body).map { |location| location['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_location.id, public_location.id)
  end

  it 'filters visible locations with Ransack params' do
    city = create(:location, universe: create(:universe, user: user), name: 'Crystal City', location_type: 'city')
    create(:location, universe: create(:universe, user: user), name: 'Crystal Harbor', location_type: 'harbor')
    public_city = create(:location, universe: create(:universe, user: other_user), name: 'Crystal City', location_type: 'city', public: true)
    create(:location, universe: create(:universe, user: other_user), name: 'Crystal City', location_type: 'city', public: false)

    get '/api/v1/locations',
      params: { q: { name_cont: 'Crystal', location_type_eq: 'city' } },
      headers: headers

    response_ids = JSON.parse(response.body).map { |location| location['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(city.id, public_city.id)
  end

  it 'does not expose another user private location' do
    location = create(:location, universe: create(:universe, user: other_user))

    get "/api/v1/locations/#{location.id}", headers: headers

    expect(response).to have_http_status(:not_found)
  end

  it 'can show another user public location' do
    location = create(:location, universe: create(:universe, user: other_user), public: true)

    get "/api/v1/locations/#{location.id}", headers: headers

    expect(response).to have_http_status(:ok)
  end

  it 'does not let users update another user public location' do
    location = create(:location, universe: create(:universe, user: other_user), public: true)

    patch "/api/v1/locations/#{location.id}", params: {
      location: { name: 'Hijacked' }
    }, headers: headers

    expect(response).to have_http_status(:forbidden)
    expect(location.reload.name).not_to eq('Hijacked')
  end

  it 'lets admins update another user private location' do
    location = create(:location, universe: create(:universe, user: other_user), public: false)

    patch "/api/v1/locations/#{location.id}", params: {
      location: { name: 'Admin Updated Location' }
    }, headers: admin_headers

    expect(response).to have_http_status(:ok)
    expect(location.reload.name).to eq('Admin Updated Location')
  end

  it 'marks whether visible locations are owned by the current user' do
    own_location = create(:location, universe: create(:universe, user: user))
    other_location = create(:location, universe: create(:universe, user: other_user), public: true)

    get '/api/v1/locations', headers: headers

    response_by_id = JSON.parse(response.body).index_by { |location| location['id'] }
    expect(response_by_id[own_location.id]['owned_by_current_user']).to be(true)
    expect(response_by_id[other_location.id]['owned_by_current_user']).to be(false)
    expect(response_by_id[other_location.id]['editable_by_current_user']).to be(false)
  end

  it 'lets users update their own location' do
    universe = create(:universe, user: user)
    world = create(:world, universe: universe)
    location = create(:location, universe: universe, public: false)

    patch "/api/v1/locations/#{location.id}", params: {
      location: {
        name: 'Updated Location',
        location_type: 'district',
        brief_description: 'Updated brief',
        full_description: 'Updated full',
        public: true,
        world_id: world.id
      }
    }, headers: headers

    expect(response).to have_http_status(:ok)
    expect(location.reload).to have_attributes(
      name: 'Updated Location',
      location_type: 'district',
      brief_description: 'Updated brief',
      full_description: 'Updated full',
      public: true,
      world_id: world.id
    )
  end
end
