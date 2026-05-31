# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'defaults to a regular profile type' do
    expect(build(:user)).to be_regular
  end

  it 'supports admin users' do
    expect(build(:user, :admin)).to be_admin
  end

  it 'assigns admin profile type to configured admin emails' do
    user = build(:user, email: 'gabrielfca222@gmail.com', profile_type: :regular)

    user.valid?

    expect(user).to be_admin
  end
end
