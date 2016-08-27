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

  def update
    @loc.update! params.require(:location).permit(:long, :lat)
    render json: @loc
  end

  def create
    new = Location.create! long: @loc_long, lat: @loc_lat
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
      loc_raw = params.require(:location)
      @loc_lat = loc_raw[:lat].to_d
      @loc_long = loc_raw[:long].to_d
    end
end
