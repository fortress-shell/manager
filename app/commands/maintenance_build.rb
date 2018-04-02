class MaintenanceBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    @build.maintenance!
  end
end
