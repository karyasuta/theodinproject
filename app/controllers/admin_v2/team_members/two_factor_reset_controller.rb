module AdminV2
  class TeamMembers::TwoFactorResetController < AdminV2::BaseController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def update
      team_member = AdminUser.find(params[:team_member_id])

      team_member.reset_two_factor!
      team_member.pending!
      team_member.create_activity(key: 'admin_user.two_factor_reset', owner: current_admin_user)
      redirect_to admin_v2_team_path, notice: "#{team_member.name} two factor reset"
    end

    private

    def record_not_found
      redirect_to admin_v2_team_path, alert: 'Team member not found'
    end
  end
end
