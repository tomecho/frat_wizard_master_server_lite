class UserController < ApplicationController
  include ApplicationHelper

  skip_before_action :auth_user, only: [:create] # may seem silly but yes you dont need to be authed for this
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
    if @user.update(user_params)
      render json: @user
    else
      render json: @user, status: 500
    end
  end

  def show
    render json: @user
  end

  def create
    email = authenticate_with_http_token do |token|
      get_email_by_token(token)
    end

    new = User.new user_params.merge(email: email)
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
    params.require(:user).permit(:first_name, :last_name)
  end

  def find_user
    @user = User.find(params.require(:id))
  end
end
