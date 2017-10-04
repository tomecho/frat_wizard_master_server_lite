# frozen_string_literal: true
require 'rails_helper'

describe ApplicationHelper do
  context 'facebook graph api' do
    it 'gets facebook profile' do
      fb_response = instance_double('response', code: '200', body: '{"test": "success"}')

      allow(Net::HTTP).to receive(:get_response) {fb_response}
      expect(get_facebook_profile_by_token('fake token', ['email'])).to include('test' => 'success')
    end

    it 'handles negative responses' do
      fb_response = instance_double('response', code: '500', body: '')

      allow(Net::HTTP).to receive(:get_response) {fb_response}
      expect(get_facebook_profile_by_token('fake token', ['email'])).to be_falsey
    end
  end
end
