require "spec_helper"
require "node_provider"
require "node_resource"

describe Chef::Resource::CouchbaseNode do
  let(:resource) { described_class.new("self") }

  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Resource }
  end

  describe "#allowed_actions" do
    subject { resource.allowed_actions }
    it { should include :nothing }
    it { should include :configure }
  end

  describe "#action" do
    it "defaults to :configure" do
      resource.action.should == :configure
    end
  end

  describe "#name" do
    it "assigns the given name attribute" do
      described_class.new("self").name.should == "self"
    end
  end

  describe "#provider" do
    it "defaults to the CouchbaseNode provider class" do
      resource.provider.should == Chef::Provider::CouchbaseNode
    end
  end
end
