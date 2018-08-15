module Api
  class GroupsController < ApplicationController
    before_action :set_group, except: %i(index create)

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
      perm_to_remove = @group.permissions.find_by_id params[:permission_id]
      if perm_to_remove
        # this shouldnt ever fail
        @group.permissions.destroy perm_to_remove
        render json: @group.permissions
      else
        render json: { errors: ['perm not found in group']}, status: :unprocessable_entity
      end
    end

    def add_permission
      perm_to_add = Permission.find_by_id params[:permission_id]
      if perm_to_add
        @group.permissions << perm_to_add
        render json: perm_to_add
      else
        render json: { errors: ['perm not found by id'] }, status: :unprocessable_entity
      end
    end

    def remove_user
      user_to_remove = @group.users.find_by_id params[:user_id]
      if user_to_remove
        @group.users.destroy user_to_remove
        render json: @group.users
      else
        render json: { errors: ['user not found in group']}, status: :unprocessable_entity
      end
    end

    def add_user
      user_to_add = User.find_by_id params[:user_id]
      if user_to_add
        @group.users << user_to_add
        render json: user_to_add
      else
        render json: { errors: ['user not found by id'] }, status: :unprocessable_entity
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:org_id, :name, :description, permission_ids: [], user_ids: [])
    end
  end
end
