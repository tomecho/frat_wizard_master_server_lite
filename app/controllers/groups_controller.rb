class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  def index
    render json: Group.all
  end

  # GET /groups/1
  def show
    render json: @group
  end

  # POST /groups
  def create
    group = Group.new(group_params)

    if group.save
      render json: group, status: :created
    else
      render json: group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    render json: @group
  end

  def remove_permission
    permission = @group.permissions.find params[:permission_id]
    permission.update(active: false)
    redirect_to edit_group_path(@group)
  end

  def add_permission
    #permission = @group.permissions.find params[:permission_id]
    #permission.update(active: true)
    #redirect_to edit_group_path(@group)
  end

  def remove_user
    user = @group.groups_users.find_by user_id: params[:user_id]
    user.update(active: false)
    redirect_to edit_group_path(@group)
  end

  def add_user
    #user = @group.groups_users.find_by user_id: params[:user_id]
    #user.update(active: true)
    #redirect_to edit_group_path(@group)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:org_id, :name, :description)
    end
end
