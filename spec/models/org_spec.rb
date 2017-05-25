require 'rails_helper'

RSpec.describe Org, type: :model do
  let(:org) { create :org }

  it 'has a valid factory' do
    expect(org).to be_valid
  end

  it 'has many users' do
    org.users << create(:user)
    org.users << create(:user)
    expect(org.users).to have_attributes count: 2
  end
end
