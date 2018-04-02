class FailBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    @build.fail!
  end
end
