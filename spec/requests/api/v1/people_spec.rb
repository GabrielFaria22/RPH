# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::People', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:admin) { create(:user, :admin) }
  let(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }
  let(:admin_headers) { { 'Authorization' => "Bearer #{admin_token}" } }

  describe 'GET /api/v1/people' do
    it 'requires authentication' do
      get '/api/v1/people'

      expect(response).to have_http_status(:unauthorized)
    end

    it 'lists only current user people' do
      own_person = create(:person, user: user)
      create(:person, user: other_user)

      get '/api/v1/people', headers: headers

      response_ids = JSON.parse(response.body).map { |person| person['id'] }
      expect(response).to have_http_status(:ok)
      expect(response_ids).to contain_exactly(own_person.id)
    end

    it 'lets admins list all people' do
      own_person = create(:person, user: user)
      other_person = create(:person, user: other_user)

      get '/api/v1/people', headers: admin_headers

      response_ids = JSON.parse(response.body).map { |person| person['id'] }
      expect(response).to have_http_status(:ok)
      expect(response_ids).to include(own_person.id, other_person.id)
    end
  end

  describe 'GET /api/v1/people/:id' do
    it 'does not expose another user person' do
      other_person = create(:person, user: other_user)

      get "/api/v1/people/#{other_person.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/people' do
    it 'creates a person for the current user' do
      post '/api/v1/people', params: {
        person: {
          first_name: 'Grace',
          last_name: 'Hopper',
          email: 'grace@example.com',
          phone: '555-0200'
        }
      }, headers: headers

      expect(response).to have_http_status(:created)
      expect(user.people.find_by(email: 'grace@example.com')).to be_present
    end
  end

  describe 'PATCH /api/v1/people/:id' do
    it 'updates a current user person' do
      person = create(:person, user: user)

      patch "/api/v1/people/#{person.id}", params: {
        person: { first_name: 'Updated' }
      }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(person.reload.first_name).to eq('Updated')
    end

    it 'lets admins update another user person' do
      person = create(:person, user: other_user)

      patch "/api/v1/people/#{person.id}", params: {
        person: { first_name: 'Admin Updated' }
      }, headers: admin_headers

      expect(response).to have_http_status(:ok)
      expect(person.reload.first_name).to eq('Admin Updated')
    end
  end

  describe 'DELETE /api/v1/people/:id' do
    it 'deletes a current user person' do
      person = create(:person, user: user)

      expect do
        delete "/api/v1/people/#{person.id}", headers: headers
      end.to change(Person, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
