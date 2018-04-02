class V1::LogsController < ApplicationController
  def index
    @build = @current_user.builds.find_by(logs_params)
  end

  private

  def logs_params
    params.permit(:build_id, :project_id)
  end
end
