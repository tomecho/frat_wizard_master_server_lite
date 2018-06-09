# frozen_string_literal: true
require 'rails_helper'

describe ApplicationHelper do
  include ApplicationHelper

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

  context 'has_permission?' do
    context 'special paths' do
      it 'allows auth paths' do
        expect(has_permission?(instance_double("Request", path: '/users/sign_in'), create(:user))).to be true
        expect(has_permission?(instance_double("Request", path: '/users/auth/facebook/callback'), create(:user))).to be true
      end

      it 'allows excluded paths' do
        expect(has_permission?(instance_double("Request", path: '/'), create(:user))).to be true
        expect(has_permission?(instance_double("Request", path: '/home'), create(:user))).to be true
        expect(has_permission?(instance_double("Request", path: '/verify_facebook_token'), create(:user))).to be true
      end
    end

    context 'checking permissions' do
      it 'passes other requests on to check permissions form user' do
        request = instance_double("Request", path: '/users/4')
        my_application_helper = Class.new.extend(ApplicationHelper.clone)
        my_application_helper.instance_eval do
          def controller_name 
            'users'
          end

          def action_name
            'show'
          end
        end
        user = double()
        allow(user).to receive(:has_permission?).with('users', 'show').and_return(false)
        expect(user).to receive(:has_permission?).with('users', 'show')

        expect(my_application_helper.has_permission?(request, user)).to be false
      end

      it 'short circuts if user is nil' do
        request = instance_double("Request", path: '/users/4')
        user = nil

        expect(has_permission?(request, user)).to be_falsey
      end
    end
  end
end
