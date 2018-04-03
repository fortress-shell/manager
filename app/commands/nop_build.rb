class NopBuild
  prepend SimpleCommand

  def call
    nil
  end
end
