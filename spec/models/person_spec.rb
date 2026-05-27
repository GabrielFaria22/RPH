require 'rails_helper'

RSpec.describe Person, type: :model do
  it 'requires a first name' do
    person = build(:person, first_name: nil)

    expect(person).not_to be_valid
    expect(person.errors[:first_name]).to include("can't be blank")
  end

  it 'requires a last name' do
    person = build(:person, last_name: nil)

    expect(person).not_to be_valid
    expect(person.errors[:last_name]).to include("can't be blank")
  end

  it 'requires a valid email' do
    person = build(:person, email: 'invalid-email')

    expect(person).not_to be_valid
    expect(person.errors[:email]).to include('is invalid')
  end

  it 'belongs to a user' do
    person = build(:person, user: nil)

    expect(person).not_to be_valid
    expect(person.errors[:user]).to include('must exist')
  end
end
