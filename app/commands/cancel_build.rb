class CancelBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    @build.aasm.fire!(:cancel)
  end
end
