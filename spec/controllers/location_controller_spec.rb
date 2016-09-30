require 'rails_helper'

RSpec.describe LocationController, type: :controller do
  it 'get #index' do
    u1 = create :user
    u1l1 = create :location, user: u1
    u1l2 = create :location, user: u1

    u2 = create :user
    u2l1 = create :location, user: u2
    u2l2 = create :location, user: u2
  
    get :index
    expect(response.body).to eq([u1l2,u2l2].to_json)
  end

  it 'get #show' do
    l = create :location
    get :show, params: { id: l.to_param }
    expect(response.body).to eq(l.to_json)
  end

  context 'post #create' do
    it 'creates a location given proper params' do
      expect do
        post :create, params: build(:location).attributes
      end.to change(Location, :count).by(1)
    end
  end
end
