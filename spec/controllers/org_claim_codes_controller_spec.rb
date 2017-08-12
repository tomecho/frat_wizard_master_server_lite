require 'rails_helper'

RSpec.describe OrgClaimCodesController, type: :controller do
  before { current_user }
  let(:claim) { create :org_claim_code }

  describe '#create' do
    context 'permissions' do
      it 'allows users from the same org with permission to create a code' do
      end
      it 'does not allow a user from a different org with perms to create a code' do
      end
      it 'does not allow a user without permission weather or not they are in the org' do
      end
    end
  end

  describe '#show' do
    it 'gives information about the supplied claim code' do
      org = create(:org_claim_code, org: create(:org, name: 'fratty frat bros'))
      get :show, params: { org_claim_code: org }
      expect(response).to have_attributes(org_name: 'fratty frat bros')
    end
  end

  describe '#destroy' do
    it 'renders the claim code inoperable but does not remove it' do
      org = create(:org_claim_code)
      expect do
        delete :destroy, params: { org_claim_code: org }
      end.to change(OrgClaimCode, :count).by 1
    end
  end
end
