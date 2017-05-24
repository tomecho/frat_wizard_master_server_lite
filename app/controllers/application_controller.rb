require 'net/http'
require 'uri'
require 'JSON'

class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :null_session
  before_action :auth_user, except: %i(verify_facebook_token)

  # sets @current_user before any other controler (execpt the public actions)
  def auth_user
    if Rails.env.test?
      # test will force set @current_user
      render(:head, status: :unauthorized) && return unless @current_user
    else
      success = false
      authenticate_with_http_token do |token, _options|
        success = use_facebook_token(token)
      end

      unless success && @current_user
        render json: nil, status: :unauthorized && return
      end

      # now check permission for the requested controller, action
      unless @current_user.has_permission?(params[:controller], params[:action])
        render json: nil, status: :forbidden && return
      end
    end
  end

  # verify token and attempt to find user, if doesnt exist, create one
  def verify_facebook_token
    authenticate_with_http_token do |token, _options|
      profile = get_facebook_profile_by_token(token, %i(email first_name last_name))

      if !profile
        # not verified, cant create
        render json: nil, status: 401 and return
      elsif user = User.find_by(email: profile['email'])
        # found valid user
        render json: user, status: 202 and return
      else
        # facebook sent us valid info lets try and create a profile
        fields = profile.with_indifferent_access.keys
        required_keys = %w(email first_name last_name)
        if (fields & required_keys) == required_keys
          user = User.new profile.select { |k| required_keys.include? k }
          if user.save
            # created user
            render json: user, status: 201 and return
          end
          # else fall through to 500
        end

        # just plain couldnt do it
        render json: nil, status: 500 and return
      end
    end
  end

  private

  # return true if token is valid, sets @current_user if we found a user
  def use_facebook_token(token)
    email = get_facebook_profile_by_token(token, %i(email))['email']
    user = User.find_by email: email
    @current_user = user
    if email
      return true
    else
      return false
    end
  end
end
