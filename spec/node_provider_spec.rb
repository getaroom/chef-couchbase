require "spec_helper"
require "node_provider"

describe Chef::Provider::CouchbaseNode do
  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Provider }
  end
end
