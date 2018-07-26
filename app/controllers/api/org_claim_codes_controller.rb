module API
  class OrgClaimCodesController < ApplicationController
    before_action :set_org_claim_code, only: %i(show destroy)

    # TODO given a claim code show the org
    def show
    end

    # create new claim code based on org_id
    def create
      # we already know this user has permission for org_claim_codes#create but we need to check they are part of this org
      unless @current_user.orgs.map(&:id).include?(new_org_claim_code_params[:org_id].to_i) || @current_user.has_permission?('*', '*')
        render json: { errors: ['user not authorized']}, status: :forbidden and return
      end

      claim = OrgClaimCode.new(new_org_claim_code_params)
      if claim.save
        render json: claim
      else
        render json: { errors: claim.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # TODO remove claim code by its id
    def destroy
    end

    private

    def set_org_claim_code
      params.require(:org_claim_codes).permit(:id)
    end

    def new_org_claim_code_params
      params.require(:org_claim_codes).permit(:org_id)
    end
  end
end
