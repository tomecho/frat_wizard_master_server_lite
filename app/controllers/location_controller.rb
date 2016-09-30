require 'JSON'
class LocationController < ApplicationController
  before_action :find_loc, only: [:show, :update]
  before_action :set_data, only: [:update, :create]

  def index
    render json: Location.latest
  end

  def show
    render json: @loc
  end

  def create
    new = Location.create! long: @loc_long, lat: @loc_lat, user_id: @user
    render json: new
  end

  def within
    point = params.permit(:long,:lat) # the point to search
    results = []
    Location.latest.each do |l|
      node = {}
      node[:name] = l.user.name
      node[:within] = l.within([point[:lat],point[:long]])
      results.push node
    end
    render json: results  
  end

  private

    def find_loc
      @loc = Location.find(params.require(:id))
    end

    def set_data
      @loc_lat = params.require(:lat)
      @loc_long = params.require(:long)
      @user = params.require(:user_id)
    end
end
