class StopBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    @build.cancel!
    @build
  end
end
