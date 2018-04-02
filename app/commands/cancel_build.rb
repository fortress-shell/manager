class CancelBuild
  prepend SimpleCommand

  def initialize(build)
    @build = build
  end

  def call
    StopJobOnNomad.call(@build).result
  end
end
