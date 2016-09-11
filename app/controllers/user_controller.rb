class UserController < ApplicationController 
  before_action :find_user, only: [:show, :update, :location]

  def index
    render json: User.all
  end

  def show
    render json: @user
  end

  def create
    new = User.create! params.require(:user).permit(:first_name, :last_name)
    render json: new
  end

  def location
    render json: @user.latest_location
  end

  private
    def find_user
      @user = User.find(params.require(:id))
    end
end
