require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  context 'facebook auth' do
    it 'returns false if token is nil' do
      a = ApplicationController.new
      expect(a.send(:use_facebook_token, nil)).to be false
    end

    it 'returns false if token is invalid' do
      a = ApplicationController.new
      expect(a.send(:use_facebook_token, 'fake token')).to be false
    end

    # TODO: test a real token maybe
  end
end
