require "spec_helper"
require "node_provider"

describe Chef::Provider::CouchbaseNode do
  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Provider }
  end

  describe "#load_current_resource" do
    pending "needs resource"
  end

  describe "#action_configure" do
    pending "needs resource"
  end
end
