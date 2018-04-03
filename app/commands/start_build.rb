class StartBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    @build.run!
    @build
  end
end
