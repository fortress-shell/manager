class V1::LogsController < ApplicationController
  def index
    @build = @current_user.builds.find(logs_params)
    unless @build
      head :not_found
    end
  end

  private

  def logs_params
    params.require(:logs).permit(:build_id, :project_id)
  end
end
