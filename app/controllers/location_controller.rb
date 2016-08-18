require 'JSON'
class LocationController < ApplicationController
  before_action :find_loc, only: [:show, :update, :within]
  before_action :set_data, only: [:update, :create]

  def index
    render json: Location.group(:user_id).having('updated_at = MAX(updated_at)')
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
    params.require(:location).require(:long,:lat) # the point to search
    render json: @loc.within
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
