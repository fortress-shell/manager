class TimeoutBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    @build.aasm.fire!(:timeout)
  end
end
