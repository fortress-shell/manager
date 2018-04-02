class SuccessBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    @build.success!
  end
end
