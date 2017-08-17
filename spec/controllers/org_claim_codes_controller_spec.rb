require 'rails_helper'

RSpec.describe OrgClaimCodesController, type: :controller do
  before { current_user }

  describe '#create' do
    context 'permissions' do
      it 'allows users from the same org with permission to create a code' do
        org = create :org

        current_user(
          create(:user, orgs: [org], groups: [
            create(:group, permissions: [
              create(:permission, controller: OrgClaimCode.name, action: 'create')
            ])
          ])
        )

        expect do
          post :create, params: { org_claim_codes: { org_id: org.id } }
        end.to change(OrgClaimCode, :count).by(1)
      end

      it 'does not allow a user from a different org with perms to create a code' do
        current_user(
          create(:user, orgs: [create(:org)], groups: [
            create(:group, permissions: [
              create(:permission, controller: OrgClaimCode.name, action: 'create')
            ])
          ])
        )

        expect do
          post :create, params: { org_claim_codes: { org_id: create(:org).id } } # a different org than we set perms for
        end.to change(OrgClaimCode, :count).by(0)
      end

      it 'does not allow a user without permission weather or not they are in the org' do
        # already has unpriveleged user set
        expect do
          post :create, params: { org_claim_codes: { org_id: create(:org).id } } # a different org than we set perms for
        end.to change(OrgClaimCode, :count).by(0)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'response' do
      it 'returns the object to requester' do
        org = create :org

        current_user(
          create(:user, orgs: [org], groups: [
            create(:group, permissions: [
              create(:permission, controller: OrgClaimCode.name, action: 'create')
            ])
          ])
        )

        post :create, params: { org_claim_codes: { org_id: org.id } }

        json = JSON.parse(response.body)
        expect(json["code"]).to be_present
        expect(json["org_id"]).to be_present
      end
    end
  end

  describe '#show' do
    it 'gives information about the supplied claim code' do
      skip('not yet implemented')
      org = create(:org_claim_code, org: create(:org, name: 'fratty frat bros'))
      get :show, params: { org_claim_code: org }
      expect(response).to have_attributes(org_name: 'fratty frat bros')
    end
  end

  describe '#destroy' do
    it 'renders the claim code inoperable but does not remove it' do
      skip('not yet implemented')
      org = create(:org_claim_code)
      expect do
        delete :destroy, params: { org_claim_code: org }
      end.to change(OrgClaimCode, :count).by 1
    end
  end
end
