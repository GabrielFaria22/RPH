# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Universes', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  it 'lists only current user universes' do
    own_universe = create(:universe, user: user)
    create(:universe, user: other_user)

    get '/api/v1/universes', headers: headers

    response_ids = JSON.parse(response.body).map { |universe| universe['id'] }
    expect(response).to have_http_status(:ok)
    expect(response_ids).to contain_exactly(own_universe.id)
  end

  it 'creates a universe for the current user' do
    post '/api/v1/universes', params: {
      universe: { name: 'Prime', description: 'Main continuity' }
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(user.universes.find_by(name: 'Prime')).to be_present
  end
end
