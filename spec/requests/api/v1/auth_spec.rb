# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  describe 'POST /api/v1/auth/signup' do
    it 'creates a user' do
      post '/api/v1/auth/signup', params: {
        user: {
          email: 'new-user@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }

      expect(response).to have_http_status(:ok)
      expect(User.find_by(email: 'new-user@example.com')).to be_present
    end

    it 'rejects weak passwords' do
      post '/api/v1/auth/signup', params: {
        user: {
          email: 'weak-password@example.com',
          password: 'short',
          password_confirmation: 'short'
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /api/v1/auth/login' do
    it 'returns a JWT for valid credentials' do
      create(:user, email: 'login@example.com', password: 'password123')

      post '/api/v1/auth/login', params: {
        user: {
          email: 'login@example.com',
          password: 'password123'
        }
      }

      expect(response).to have_http_status(:ok)
      expect(response.headers['Authorization']).to start_with('Bearer ')
      expect(JSON.parse(response.body)['token']).to be_present
    end

    it 'rejects invalid credentials' do
      create(:user, email: 'login@example.com', password: 'password123')

      post '/api/v1/auth/login', params: {
        user: {
          email: 'login@example.com',
          password: 'wrong-password'
        }
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /api/v1/auth/logout' do
    it 'requires authentication' do
      delete '/api/v1/auth/logout'

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
