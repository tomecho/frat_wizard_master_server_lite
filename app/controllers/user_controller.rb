class UserController < ApplicationController 
  before_action :find_user, only: [:show, :update, :location]

  def index
    page = params[:page]
    if page
      render json: User.paginate(page: page).to_a
    else
      render json: User.all
    end
  end

  def show
    render json: @user
  end

  def create
    new = User.create! params.require(:user).permit(:first_name, :last_name, :email)
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
