# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Universes', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:admin) { create(:user, :admin) }
  let(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }
  let(:admin_headers) { { 'Authorization' => "Bearer #{admin_token}" } }

  it 'lists current user universes and public universes by default' do
    own_universe = create(:universe, user: user)
    public_universe = create(:universe, user: other_user, public: true)
    create(:universe, user: other_user, public: false)

    get '/api/v1/universes', headers: headers

    response_ids = JSON.parse(response.body).map { |universe| universe['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_universe.id, public_universe.id)
  end

  it 'lets admins list all universes' do
    public_universe = create(:universe, user: other_user, public: true)
    private_universe = create(:universe, user: other_user, public: false)

    get '/api/v1/universes', headers: admin_headers

    response_ids = JSON.parse(response.body).map { |universe| universe['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to include(public_universe.id, private_universe.id)
  end

  it 'lists only current user universes from the mine endpoint' do
    own_universe = create(:universe, user: user, name: 'My Prime Universe')
    create(:universe, user: other_user, name: 'My Prime Universe', public: true)

    get '/api/v1/universes/mine', headers: headers

    response_ids = JSON.parse(response.body).map { |universe| universe['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_universe.id)
  end

  it 'searches visible universes by default' do
    own_universe = create(:universe, user: user, name: 'My Prime Universe')
    public_universe = create(:universe, user: other_user, public: true)
    public_universe.update!(name: 'My Prime Universe')
    create(:universe, user: other_user, name: 'My Prime Universe', public: false)

    get '/api/v1/universes', params: { q: 'Prime' }, headers: headers

    response_ids = JSON.parse(response.body).map { |universe| universe['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_universe.id, public_universe.id)
  end

  it 'searches only current user universes from the mine endpoint' do
    own_universe = create(:universe, user: user, name: 'My Prime Universe')
    create(:universe, user: other_user, name: 'My Prime Universe', public: true)

    get '/api/v1/universes/mine', params: { q: 'Prime' }, headers: headers

    response_ids = JSON.parse(response.body).map { |universe| universe['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_universe.id)
  end

  it 'filters and sorts visible universes with Ransack params' do
    later_universe = create(:universe, user: user, name: 'Zephyr Verse', genre: 'fantasy', public: true)
    earlier_universe = create(:universe, user: other_user, name: 'Aurora Verse', genre: 'fantasy', public: true)
    create(:universe, user: user, name: 'Neon Verse', genre: 'cyberpunk', public: true)
    create(:universe, user: other_user, name: 'Hidden Verse', genre: 'fantasy', public: false)

    get '/api/v1/universes',
      params: { q: { name_cont: 'Verse', genre_eq: 'fantasy', s: 'name desc' } },
      headers: headers

    response_ids = JSON.parse(response.body).map { |universe| universe['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to eq([later_universe.id, earlier_universe.id])
  end

  it 'can show another user public universe' do
    public_universe = create(:universe, user: other_user, public: true)

    get "/api/v1/universes/#{public_universe.id}", headers: headers

    expect(response).to have_http_status(:ok)
  end

  it 'does not show another user private universe' do
    private_universe = create(:universe, user: other_user, public: false)

    get "/api/v1/universes/#{private_universe.id}", headers: headers

    expect(response).to have_http_status(:not_found)
  end

  it 'does not let users update another user public universe' do
    public_universe = create(:universe, user: other_user, public: true)

    patch "/api/v1/universes/#{public_universe.id}", params: {
      universe: { name: 'Hijacked' }
    }, headers: headers

    expect(response).to have_http_status(:forbidden)
    expect(public_universe.reload.name).not_to eq('Hijacked')
  end

  it 'lets admins update another user private universe' do
    universe = create(:universe, user: other_user, public: false)

    patch "/api/v1/universes/#{universe.id}", params: {
      universe: { name: 'Admin Updated Universe' }
    }, headers: admin_headers

    expect(response).to have_http_status(:ok)
    expect(universe.reload.name).to eq('Admin Updated Universe')
  end

  it 'marks whether visible universes are owned by the current user' do
    own_universe = create(:universe, user: user)
    other_universe = create(:universe, user: other_user, public: true)

    get '/api/v1/universes', headers: headers

    response_by_id = JSON.parse(response.body).index_by { |universe| universe['id'] }
    expect(response_by_id[own_universe.id]['owned_by_current_user']).to be(true)
    expect(response_by_id[other_universe.id]['owned_by_current_user']).to be(false)
    expect(response_by_id[other_universe.id]['editable_by_current_user']).to be(false)
  end

  it 'marks visible universes editable for admins' do
    universe = create(:universe, user: other_user, public: true)

    get '/api/v1/universes', headers: admin_headers

    response_by_id = JSON.parse(response.body).index_by { |item| item['id'] }
    expect(response_by_id[universe.id]['owned_by_current_user']).to be(false)
    expect(response_by_id[universe.id]['editable_by_current_user']).to be(true)
  end

  it 'lets users update their own universe' do
    universe = create(:universe, user: user, public: false)

    patch "/api/v1/universes/#{universe.id}", params: {
      universe: { name: 'Updated Universe', genre: 'urban fantasy', description: 'Updated notes', public: true }
    }, headers: headers

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['genre']).to eq('urban fantasy')
    expect(universe.reload).to have_attributes(
      name: 'Updated Universe',
      genre: 'urban_fantasy',
      description: 'Updated notes',
      public: true
    )
  end

  it 'creates a universe for the current user' do
    post '/api/v1/universes', params: {
      universe: { name: 'Prime', genre: 'sci-fi', description: 'Main continuity', public: true }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)['genre']).to eq('sci-fi')
    expect(user.universes.find_by(name: 'Prime', genre: 'sci-fi', public: true)).to be_present
  end
end
