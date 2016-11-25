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

  def update
    @user.update user_params
    if @user.save
      render json: @user
    else
      render json: @user, status: 500
    end
  end

  def show
    render json: @user
  end

  def create
    new = User.new user_params
    if new.save
      render json: new
    else
      render json: nil, status: 500
    end
  end

  def location
    render json: @user.latest_location
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

  def find_user
    @user = User.find(params.require(:id))
  end
end
