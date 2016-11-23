require "net/http"
require "uri"
require "JSON"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :auth_user

  def auth_user
    if Rails.env.production?
      use_facebook_token(request.headers["auth_token"])
      render nothing: true, status: :unauthorized and return unless session[:user]
    end
  end

  private 

    def use_facebook_token(token)
      return false if token.nil?
      uri = URI.parse "https://graph.facebook.com/me?fields=email&access_token=#{token}"
      fb = Net::HTTP.get_response(uri)
      
      if fb && fb.code == 200 
        email = JSON.parse(fb.body)["email"] # if this exists then facebook has verified the token and found user for it
        session[:user] = User.find_by email: email
        return true if session[:user]
      end
      return false
    end
end
