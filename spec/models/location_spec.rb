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

  it 'returns default radius' do
    expect(Location.default_radius).not_to be_nil
  end

  context 'within' do
    it 'returns true if within' do
      raw_a = Geocoder.coordinates('25 Main St, Cooperstown, NY')
      raw_b = Geocoder.coordinates('26 Main St, Cooperstown, NY') # next door!
      a = create :location, long: raw_a[1], lat: raw_a[0]
      b = create :location, long: raw_b[1], lat: raw_a[0]
      expect(a.within([b.lat, b.long])).to be true
    end

    it 'returns false if not within' do
      raw_a = Geocoder.coordinates('25 Main St, Cooperstown, NY')
      raw_b = Geocoder.coordinates('4 Wells Rd, Ellington, CT') # next nearly next oor
      a = create :location, long: raw_a[1], lat: raw_a[0]
      b = create :location, long: raw_b[1], lat: raw_a[0]
      expect(a.within([b.lat, b.long])).to be false
    end
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
