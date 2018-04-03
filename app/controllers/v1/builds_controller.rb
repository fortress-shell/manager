class V1::BuildsController < ApplicationController
  before_action :set_build, except: :index

  def index
    @builds = @current_user.builds.where(build_params)
  end

  def show
  end

  def logs
  end

  private

  def set_build
    @build = @current_user.builds.find_by!(build_params)
  end

  def build_params
    params.permit(:id, :project_id)
  end
end
