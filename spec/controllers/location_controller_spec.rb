require 'rails_helper'

RSpec.describe LocationController, type: :controller do
  before { current_user } # sets user

  it 'get #index' do
    u1 = create :user
    u1l1 = create :location, user: u1
    u1l2 = create :location, user: u1

    u2 = create :user
    u2l1 = create :location, user: u2
    u2l2 = create :location, user: u2

    get :index
    expect(response.body).to eq([u1l2, u2l2].to_json)
  end

  it 'get #show' do
    l = create :location
    get :show, params: { id: l.to_param }
    expect(response.body).to eq(l.to_json)
  end

  context 'get #within' do
    before(:each) do
      @l1 = create :location, long: 1, lat: 1
      @l2 = create :location, long: 1, lat: 1
      @l3 = create :location, long: 1, lat: 50
    end

    it 'returns the points within the submitted location' do
      get :within, params: { long: 1, lat: 1 }
      expect(JSON.parse(response.body).collect { |x| x['name'] }).to eq([@l1.user.name, @l2.user.name])
    end

    it 'properly handles nil params' do
      get :within, params: {}
      expect(JSON.parse(response.body).collect { |x| x['name'] }).to be_empty
    end
  end

  context 'post #create' do
    it 'creates a location given proper params' do
      expect do
        post :create, params: build(:location).attributes
      end.to change(Location, :count).by(1)
    end

    it 'renders 500 on failure' do
      expect do
        post :create, params: {}
      end.to change(Location, :count).by(0)
      expect(response.code).to eq('500')
      expect(response.body).not_to be nil
    end
  end
end
