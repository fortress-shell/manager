class FailBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    @build.aasm.fire!(:fail)
  end
end
