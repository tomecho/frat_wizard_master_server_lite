require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  context 'validations' do
    it 'validates presence of name' do
      expect(build(:user, name: nil)).not_to be_valid
      expect(build(:user, name: '')).not_to be_valid
    end

    it 'validates presnece of email' do
      expect(build(:user, email: nil)).not_to be_valid
      expect(build(:user, email: '')).not_to be_valid
    end
  end

  context 'orgs' do
    it 'has assigned org' do
      expect(build(:user, orgs: [ create(:org) ])).to have_attributes orgs: [ Org.last ]
    end

    it 'can have many orgs' do
      expect(build(:user, orgs: create_list(:org, 2)).orgs).to match_array Org.all.last(2)
    end
  end

  context 'helper methods' do
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

    context 'helps with permissions' do
      it 'positivly verifies perms' do
        u = create :user, groups: [ create(:group, permissions: [create(:permission, controller: 'fake', action: 'for_test')])]
        expect(u.has_permission?('fake', 'for_test')).to be true
      end
      it 'negativly verifies perms' do
        u = create :user, groups: [ create(:group, permissions: [create(:permission, controller: 'fake', action: 'for_test')])]
        expect(u.has_permission?('dont', 'have')).to be false
      end
      it 'consider special permissions' do
        u = create :user, groups: [ create(:group, permissions: [Permission.find_by(controller: '*', action: '*')])]
        expect(u.has_permission?('dont', 'have')).to be true
      end
    end

    context 'org claim codes' do
      it 'joins an org with a valid claim code' do
        org = create :org
        claim = create :org_claim_code, org: org
        u = create(:user)
        u.use_org_claim_code(claim.code)
        expect(u.reload.orgs).to include org
      end

      it 'doesnt join an org given a fake code' do
        u = create :user
        expect do
          u.use_org_claim_code('fake code')
        end.to change(u.orgs,:count).by(0)
      end
    end
  end

  it 'has implicit children' do
    one = create(:location, user: user)
    two = create(:location, user: user)
    expect(user.location).to eq([one, two])
  end
end
