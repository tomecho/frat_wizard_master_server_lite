require 'rails_helper'
RSpec.describe :permission, type: :model do
  it 'has a valid factory' do
    expect(build(:permission)).to be_valid
  end
end
