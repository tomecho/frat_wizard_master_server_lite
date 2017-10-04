class EventController < ApplicationController

  def index
    render json: Event.where('start_time < ?', '2017-11-07 16:32:28.268106').
      limit(10).order('start_time asc')
  end

  def show
    @event = Event.find(params[:id])
  end


end
