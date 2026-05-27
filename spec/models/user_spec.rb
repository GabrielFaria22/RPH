require 'rails_helper'

RSpec.describe User, type: :model do
  it 'hashes passwords instead of storing them directly' do
    user = create(:user, password: 'password123', password_confirmation: 'password123')

    expect(user.encrypted_password).to be_present
    expect(user.encrypted_password).not_to eq('password123')
    expect(user.valid_password?('password123')).to be(true)
  end

  it 'destroys dependent people' do
    user = create(:user)
    create(:person, user: user)

    expect { user.destroy }.to change(Person, :count).by(-1)
  end
end
