class StopBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    @build.cancel!
  end
end
