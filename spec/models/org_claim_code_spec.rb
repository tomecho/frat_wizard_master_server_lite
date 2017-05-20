require 'rails_helper'

RSpec.describe OrgClaimCode, type: :model do
  context 'validations' do
    it 'has a valid factory' do
      expect(build(:org_claim_code)).to be_valid
    end
  end
end
