require 'rails_helper'

RSpec.describe OrgClaimCode, type: :model do
  context 'validations' do
    it 'has a valid factory' do
      expect(build(:org_claim_code)).to be_valid
    end
  end

  context 'using claim code' do
    it 'uses a basic claim code' do
      claim = create :org_claim_code
      expect(create(:user, org_claim_code: claim.code)).to have_attributes orgs: [ claim.org ]
    end
  end
end
