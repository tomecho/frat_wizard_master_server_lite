require 'rails_helper'

RSpec.describe Location, type: :model do
  it 'has a valid factory' do
    expect(build(:location)).to be_valid
  end

  context 'validations' do
    it 'validates attributes' do
      expect(build(:location, long: nil)).not_to be_valid
      expect(build(:location, lat: nil)).not_to be_valid
      expect(build(:location, user_id: nil)).not_to be_valid
    end
  end

  it 'calculates within correctly' do
    {"long"=>'-72.5256815', "lat"=>'42.3918886'}
  end

  it 'properly gets latest of each location for user' do
    u1 = create :user
    u2 = create :user
    create(:location, user: u1)
    u1_latest = create(:location, user: u1)
    create(:location, user: u2)
    u2_latest = create(:location, user: u2)
    expect(Location.latest).to eq([u1_latest, u2_latest])
  end
end
