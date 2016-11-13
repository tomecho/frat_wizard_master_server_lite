require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  context 'facebook auth' do
    it 'returns false if token is nil' do
      a = ApplicationController.new
      expect(a.send(:use_facebook_token, nil)).to be false
    end
  end
end
