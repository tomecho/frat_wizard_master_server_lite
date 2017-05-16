require 'rails_helper'

RSpec.describe Org, type: :model do
  let(:org) { create :org }

  it 'has a valid factory' do
    expect(org).to be_valid
  end
end
