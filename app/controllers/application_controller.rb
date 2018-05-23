require 'net/http'
require 'uri'
require 'json'

class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :null_session
  before_action :auth_user, except: %i(verify_facebook_token)
  before_action :check_permission, except: %i(verify_facebook_token home)

  # sets @current_user before any other controler (execpt the public actions)
  def auth_user
    if Rails.env.test?
      # test will force set @current_user
      unless @current_user
        render json: { errors: ['unauthorized'] }, status: :unauthorized and return
      end
    else
      # its an api request (from mobile app)
      if request_for_api?(request)
        profile = nil
        authenticate_with_http_token do |token, _options|
          profile = get_facebook_profile_by_token(token, %i(email))
        end
        if profile
          @current_user = User.find_by_email profile['email']
          unless @current_user
            render json: { errors: ['could not set user given a valid facebook profile, account needs to be created'] }, status: :forbidden and return
          end
        else
          render json: { errors: ['could not find facebook profile'] }, status: :unauthorized and return
        end
      else
        # else its a request for our web based app set user from session for force them to auth using omni auth
        authenticate_user!
      end
    end
  end

  def check_permission
    unless has_permission?(params[:controller], params[:action], @current_user)
      render json: { errors: ['user does not have permissions'] }, status: :unauthorized and return
    end
  end

  # verify token and attempt to find user, if doesnt exist, create one
  def verify_facebook_token
    authenticate_with_http_token do |token, _options|
      profile = get_facebook_profile_by_token(token, %i(email first_name last_name))

      if !profile
        # not verified, cant create
        render json: {errors: ['could not find profile from facebook']}, status: 401 and return
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
          # very unlikely that it will fail
        end

        render json: { errors: ['failed to create user from facebook profile']}, status: 500 and return
      end
    end
    # above block will use token and return if they dont find one we get here
    render json: { errors: ['authorization token not supplied']}, status: 422 and return
  end

  def home
    render 'home', template: 'home'
  end

  def login
  end
end
