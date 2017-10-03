require 'net/http'
require 'uri'
require 'JSON'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :auth_user, except: [:verify_facebook_token]

  def auth_user
    if Rails.env.test?
      # test will force set @current_user
      render(:head, status: :unauthorized) && return unless @current_user
    else
      authenticate_with_http_token do |token, _options|
        success = use_facebook_token(token)
      end

      unless success && @current_user
        render(:head, status: :unauthorized) && return
      end
    end
  end

  def verify_facebook_token
    binding.pry
    success = false
    authenticate_with_http_token do |token, _options|
      success = use_facebook_token(token)
    end

    if success && @current_user # verified and found user
      render nothing: true, status: 202 # accepted
    elsif success && !@current_user # verified but no user found
      render nothing: true, status: 204
    else # not verified
      render nothing: true, status: 401
    end
  end

  private

  def use_facebook_token(token)
    binding.pry
    return false if token.nil?
    uri = URI.parse "https://graph.facebook.com/me?fields=email&access_token=#{token}"
    fb = Net::HTTP.get_response(uri)

    if fb && fb.code == '200'
      email = JSON.parse(fb.body)['email'] # if this exists then facebook has verified the token and found user for it
      user = User.find_by email: email
      @current_user = user
      return true if email
    end
    false
  end
end
