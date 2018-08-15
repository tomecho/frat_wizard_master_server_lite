require 'rails_helper'

RSpec.describe Api::OrgClaimCodesController, type: :controller do
  let(:org) { create(:org) }

  describe '#create' do
    context 'permissions' do
      it 'allows users from the same org with permission to create a code' do
        current_user(
          create(:user, orgs: [org], groups: [
            create(:group, permissions: [
              Permission.find_by(controller: 'api/org_claim_codes', action: 'create')
            ])
          ])
        )

        expect do
          post :create, params: { org_claim_codes: { org_id: org.id } }
        end.to change(OrgClaimCode, :count).by(1)
      end

      it 'does allow if they are a super user' do
        current_user(super_user) # that guy has all the perms
        expect do
          post :create, params: { org_claim_codes: { org_id: org.id } }
        end.to change(OrgClaimCode, :count).by(1)
      end

      it 'does not allow a user from a different org with perms to create a code' do
        current_user(
          create(:user, orgs: [create(:org)], groups: [
            create(:group, permissions: [
              Permission.find_by(controller: 'api/org_claim_codes', action: 'create')
            ])
          ])
        )

        expect do
          post :create, params: { org_claim_codes: { org_id: create(:org).id } } # a different org than we set perms for
        end.to change(OrgClaimCode, :count).by(0)

        expect(response).to have_http_status(:forbidden) # from application controller check permission
      end

      it 'does not allow a user without permission weather or not they are in the org' do
        current_user
        expect do
          post :create, params: { org_claim_codes: { org_id: create(:org).id } } # a different org than we set perms for
        end.to change(OrgClaimCode, :count).by(0)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'response' do
      it 'returns the object to requester' do
        current_user(
          create(:user, orgs: [org], groups: [
            create(:group, permissions: [
              Permission.find_by(controller: 'api/org_claim_codes', action: 'create')
            ])
          ])
        )

        post :create, params: { org_claim_codes: { org_id: org.id } }

        json = JSON.parse(response.body)
        expect(json["code"]).to be_present
        expect(json["org_id"]).to be_present
      end
      it 'can recover from errors' do
        skip('find way to test this')
        expect(response).to have_http_status 422
      end
    end
  end

  describe '#show' do
    it 'gives information about the supplied claim code' do
      skip('not yet implemented')
      org = create(:org_claim_code, org: create(:org, name: 'fratty frat bros'))
      get :show, params: { org_claim_code: org }
      expect(JSON.parse(response)).to have_attributes(org_name: 'fratty frat bros')
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
