module FixtureSupport
  def fixture(path)
    File.new(File.expand_path(File.join(__FILE__, "..", "..", "fixtures", path)))
  end
end

RSpec.configuration.include FixtureSupport
