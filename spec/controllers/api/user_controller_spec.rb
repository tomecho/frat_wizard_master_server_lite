require 'rails_helper'

RSpec.describe UserController, type: :controller do
  let(:u1) { create :user }
  let(:u2) { create :user }
  let!(:lots_of_users) { create_list :user, 5 }

  context 'get #index' do
    it 'renders a list of all users' do
      get :index
      expect(JSON.parse(response.body).collect { |u| u['name'] }).to eq(User.all.collect(&:name))
    end

    it 'handles pagination' do
      # lots_of_users
      get :index, params: { page: 1 }
      expect(JSON.parse(response.body).collect { |u| u['name'] }).to eq(User.all[0...10].collect(&:name))
    end
  end

  it 'get #show' do
    get :show, params: { id: u1.id }
    expect(response.body).to eq(u1.to_json)
  end

  context 'get #location' do
    it 'renders nil on empty' do
      get :location, params: { id: u1.id }
      expect(response.body).to eq('null')
    end

    it 'renders latest location' do
      locs = create_list :location, 5, user: u1
      get :location, params: { id: u1.id }
      expect(response.body).to eq(locs.last.to_json)
    end
  end

  context 'put #update' do
    it 'updates the record given valid params' do
      put :update, params: { id: u1.id, user: { name: 'el chapo' } }
      u1.reload
      expect(u1.name).to eq('el chapo')
      expect(response.code).to eq('200')
      expect(JSON.parse(response.body)).to eq(JSON.parse(u1.to_json))
    end
  end

  context 'POST #use_org_claim_code' do
    it 'uses the code to join an org' do
      u1
      claim = create :org_claim_code
      expect do
        post :use_org_claim_code, params: { id: u1.id, org_claim_code: claim.code }
      end.to change(u1.orgs,:count).by(1)
      expect(u1.orgs.last).to eq claim.org
      expect(response).to have_http_status :ok
      expect(response.body).to eq(claim.org.to_json)
    end

    it 'wont join an org using a fake code' do
      u1
      expect do
        post :use_org_claim_code, params: { id: u1.id, org_claim_code: 'fake' }
      end.to change(u1.orgs,:count).by(0)
      expect(response).to have_http_status 422
    end
  end
end
