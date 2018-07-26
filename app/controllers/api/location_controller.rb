class LocationController < ApplicationController
  before_action :find_loc, only: [:show]
  before_action :set_data, only: [:create]

  def index
    render json: Location.latest
  end

  def show
    render json: @loc
  end

  def create
    new = Location.new long: @loc_long, lat: @loc_lat, user_id: @current_user.id
    if new.save
      render json: new
    else
      render json: new.errors, status: 500
    end
  end

  def within
    point = params.permit(:long, :lat) # the point to search
    results = []
    Location.latest.each do |l|
      next unless l.within([point[:lat], point[:long]])
      node = {}
      node[:name] = l.user.name
      node[:within] = true
      results.push node
    end
    render json: results
  end

  private

  def find_loc
    @loc = Location.find(params.require(:id))
  end

  def set_data
    @loc_lat = params[:lat]
    @loc_long = params[:long]
  end
end
