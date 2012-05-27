require "spec_helper"
require "settings_resource"

describe Chef::Resource::CouchbaseSettings do
  let(:resource) { described_class.new("web") }
  it_should_behave_like "a resource with couchbase credentials"

  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Resource }
  end

  describe "#action" do
    it "defaults to :modify" do
      resource.action.should == :modify
    end
  end

  describe "#allowed_actions" do
    subject { resource.allowed_actions }
    it { should include :nothing }
    it { should include :modify }
  end

  describe "#group" do
    it "can be assigned" do
      resource.group "web"
      resource.group.should == "web"
    end

    it "cannot be assigned an Integer" do
      expect { resource.group 42 }.to raise_error Chef::Exceptions::ValidationFailed
    end

    it "defaults to the name attribute" do
      resource.group.should == resource.name
    end
  end

  describe "#resource_name" do
    subject { resource.resource_name }
    it { should == :couchbase_settings }
  end

  describe "#settings" do
    it "can be assigned" do
      resource.settings({})
      resource.settings.should == {}
    end

    it "cannot be assigned a String" do
      expect { resource.settings "sendStats=true" }.to raise_error Chef::Exceptions::ValidationFailed
    end

    it "is required" do
      expect { resource.settings }.to raise_error Chef::Exceptions::ValidationFailed
    end
  end
end
