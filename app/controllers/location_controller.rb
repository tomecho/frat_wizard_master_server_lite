require 'JSON'
class LocationController < ApplicationController
  before_action :find_loc, only: [:show, :update]
  before_action :set_data, only: [:update, :create]
  def show
    render json: @loc
  end

  def create
    if (new = Location.create long: @loc_long, lat: @loc_lat, user_id: @user)
      render json: new
    end
  end

  private
    def find_loc
      @loc = Location.find(params.require(:id))
    end

    def set_data
      @user = params.require(:user)
      loc_raw = params.require(:location)
      @loc_lat = loc_raw[:lat].to_d
      @loc_long = loc_raw[:long].to_d
    end
end
