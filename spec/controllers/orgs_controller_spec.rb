require 'rails_helper'

RSpec.describe OrgsController, type: :controller do
  let(:org) { create :org }
  let(:valid_attributes) { attributes_for :org }

  describe 'GET #index' do
    it 'assigns all orgs as @orgs' do
      org
      get :index
      expect(response.body).to eq(Org.all.to_json)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested org as @org' do
      get :show, params: { id: org.to_param }
      expect(assigns(:org)).to eq(org)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Org' do
        expect do
          post :create, params: { org: valid_attributes }
        end.to change(Org, :count).by(1)
      end

      it 'assigns a newly created org as @org' do
        post :create, params: { org: valid_attributes }
        expect(assigns(:org)).to be_a(Org)
        expect(assigns(:org)).to be_persisted
      end

      it 'redirects to the created org' do
        post :create, params: { org: valid_attributes }
        expect(response).to have_attributes body: Org.last.to_json
      end
    end

    context 'with invalid params' do
      it 'dosnt create an invalid org' do
        expect do
          post :create, params: { org: { fake: 'param' } }
        end.not_to change(Org, :count)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested org' do
        put :update, params: { id: org.to_param, org: { name: 'new name' } }
        org.reload
        expect(org).to have_attributes name: 'new name'
      end

      it 'assigns the requested org as @org' do
        put :update, params: { id: org.to_param, org: valid_attributes }
        expect(assigns(:org)).to eq(org)
      end
    end

    context 'with invalid params' do
      it 'assigns the org as @org' do
        put :update, params: { id: org.to_param, org: { random: 'thing' } }
        expect(assigns(:org)).to eq(org)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested org' do
      org
      expect do
        delete :destroy, params: { id: org.to_param }
      end.to change(Org, :count).by(-1)
      expect(response.body).to be_empty
    end
  end
end
