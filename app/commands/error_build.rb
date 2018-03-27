class ErrorBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    @build.aasm.fire!(:error)
  end
end
