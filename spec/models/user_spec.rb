require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  context 'validations' do
    it 'validates presence of name' do
      expect(build(:user, first_name: nil)).not_to be_valid
      expect(build(:user, last_name: nil)).not_to be_valid
    end

    it 'validates presnece of email' do
      expect(build(:user, email: nil)).not_to be_valid
    end

    it 'is valid w/o org' do
      binding.pry
      expect(build(:user, org: create(:org))).to have_attributes org => org.last
    end
  end

  context 'helper methods' do
    it 'gives a full name' do
      expect(user.name).to eq("#{user.first_name} #{user.last_name}")
    end

    context 'latest_location' do
      it 'returns nil without locations' do
        expect(user.latest_location).to be_nil
      end

      it 'yields the latest location through the helper method' do
        create(:location, user: user)
        latest = create(:location, user: user)
        expect(user.latest_location).to eq(latest)
      end
    end
  end

  it 'has implicit children' do
    one = create(:location, user: user)
    two = create(:location, user: user)
    expect(user.location).to eq([one, two])
  end
end
