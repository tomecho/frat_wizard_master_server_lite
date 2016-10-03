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
      expect(response.body).to eq(lots_of_users[0...10]) # the first ten users
    end
  end
end
