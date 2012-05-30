require "spec_helper"
require "bucket_resource"

describe Chef::Resource::CouchbaseBucket do
  let(:resource) { described_class.new "default" }
  it_should_behave_like "a resource with couchbase credentials"

  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Resource }
  end

  describe "#action" do
    it "defaults to :create" do
      resource.action.should == :create
    end
  end

  describe "#allowed_actions" do
    subject { resource.allowed_actions }
    it { should include :create }
    it { should include :nothing }
  end

  describe "#bucket_name" do
    it "can be assigned a String" do
      resource.bucket_name "default"
      resource.bucket_name.should == "default"
    end

    it "cannot be assigned an Integer" do
      expect { resource.bucket_name 42 }.to raise_error Chef::Exceptions::ValidationFailed
    end

    it "defaults to the name attribute" do
      resource.bucket_name.should == resource.name
    end
  end

  describe "#exists" do
    it "can be assigned true" do
      resource.exists true
      resource.exists.should == true
    end

    it "can be assigned false" do
      resource.exists false
      resource.exists.should == false
    end

    it "cannot be assigned an Integer" do
      expect { resource.exists 42 }.to raise_error Chef::Exceptions::ValidationFailed
    end

    it "cannot be assigned nil" do
      expect { resource.exists nil }.to raise_error Chef::Exceptions::ValidationFailed
    end
  end

  describe "#memory_quota_mb" do
    it "can be assigned" do
      resource.memory_quota_mb 512
      resource.memory_quota_mb.should == 512
    end

    it "cannot be assigned a String" do
      expect { resource.memory_quota_mb "happy" }.to raise_error Chef::Exceptions::ValidationFailed
    end

    it "cannot be assigned a Float" do
      expect { resource.memory_quota_mb 512.5 }.to raise_error Chef::Exceptions::ValidationFailed
    end

    it "can be assigned 100" do
      resource.memory_quota_mb 100
      resource.memory_quota_mb.should == 100
    end

    it "cannot be assigned 99" do
      expect { resource.memory_quota_mb 99 }.to raise_error Chef::Exceptions::ValidationFailed, "Option memory_quota_mb's value 99 must be at least 100!"
    end

    it "cannot be assigned a negative number" do
      expect { resource.memory_quota_mb -1 }.to raise_error Chef::Exceptions::ValidationFailed, "Option memory_quota_mb's value -1 must be at least 100!"
    end

    it "is required" do
      expect { resource.memory_quota_mb }.to raise_error Chef::Exceptions::ValidationFailed
    end
  end

  describe "#replicas" do
    it "can be assigned 1" do
      resource.replicas 1
      resource.replicas.should == 1
    end

    it "cannot be assigned a String" do
      expect { resource.replicas "one" }.to raise_error Chef::Exceptions::ValidationFailed
    end

    it "cannot be assgned a Float" do
      expect { resource.replicas 1.5 }.to raise_error Chef::Exceptions::ValidationFailed
    end

    it "can be assigned false" do
      resource.replicas false
      resource.replicas.should be_false
    end

    it "cannot be assigned a negative number" do
      expect { resource.replicas -3 }.to raise_error Chef::Exceptions::ValidationFailed, "Option replicas's value -3 must be a non-negative integer!"
    end

    it "cannot be assigned -1" do
      expect { resource.replicas -1 }.to raise_error Chef::Exceptions::ValidationFailed, "Option replicas's value -1 must be a non-negative integer!"
    end

    it "can be assigned 0" do
      resource.replicas 0
      resource.replicas.should == 0
    end

    it "defaults to 1" do
      resource.replicas.should == 1
    end
  end

  describe "#resource_name" do
    subject { resource.resource_name }
    it { should == :couchbase_bucket }
  end
end
