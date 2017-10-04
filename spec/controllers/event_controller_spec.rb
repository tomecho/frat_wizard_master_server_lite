require 'rails_helper'

RSpec.describe EventController, type: :controller do
  before { current_user } # sets the current user to something
  describe '#index' do
    it 'grabs the first events' do
      create_list :event, 5 # uses FactoryGirl
      get :index
      expect(response.body) # have to parse json as object
        .to eq Event.all.to_a.to_json
    end
  end


end
