class CancelBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call

  end
end
