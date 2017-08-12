class UserController < ApplicationController
  before_action :find_user, except: %i(index)

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

  def location
    render json: @user.latest_location
  end

  def use_org_claim_code
    # that method returns which if any org was joined
    render json: @user.use_org_claim_code(params.require(:org_claim_code))
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end

  def find_user
    @user = User.find(params.require(:id))
  end
end
