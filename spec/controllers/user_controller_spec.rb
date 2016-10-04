require 'rails_helper'

RSpec.describe UserController, type: :controller do

  let(:u1) { create :user }
  let(:u2) { create :user }
  let!(:lots_of_users) { create_list :user, 20 }

  context 'get #index' do
    it 'renders a list of all users' do
      get :index
      expect(JSON.parse(response.body).collect { |u| u["first_name"] + " " + u["last_name"] }).to eq(lots_of_users.collect { |u| u.first_name + " " + u.last_name })
    end

    it 'handles pagination' do
      lots_of_users
      get :index, params: {page: 1}
      expect(JSON.parse(response.body).collect { |u| u["first_name"] + " " + u["last_name"] }).to eq(lots_of_users[0...10].collect { |u| u.first_name + " " + u.last_name })
    end
  end

  it 'get #show' do
    get :show, params: {id: u1.id}
    expect(response.body).to eq(u1.to_json)
  end

  context 'get #location' do
    it 'renders nil on empty' do
      get :location, params: {id: u1.id}
      expect(response.body).to eq("null")
    end

    it 'renders latest location' do
      locs = create_list :location, 5, user: u1
      get :location, params: {id: u1.id}
      expect(response.body).to eq(locs.last.to_json)
    end
  end

  context 'put #update' do
    it 'updates the record given valid params' do
      put :update, params: { id: u1.id, user: { first_name: 'el', last_name: 'chapo' } }
      u1.reload
      expect(u1.first_name).to eq('el')
      expect(u1.last_name).to eq('chapo')
      expect(response.code).to eq("200")
      expect(JSON.parse(response.body)).to eq(JSON.parse(u1.to_json))
    end
  end

  context 'post #create' do
    it 'creates a record given valid params' do
      user = attributes_for(:user)
      expect do
        post :create, params: { user: user }
      end.to change(User, :count).by(1)
      expect(response.code).to eq("200")
    end

    it 'returns given invalid params' do
      expect do
        post :create, params: {  }
      end.to raise_error
    end
  end
end
