require "spec_helper"
require "cluster_provider"
require "cluster_resource"

describe Chef::Provider::CouchbaseCluster do
  let(:provider) { described_class.new(new_resource, stub("run_context")) }
  let(:new_resource) { stub(:name => "my new pool", :id => "default") }

  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Provider }
  end

  describe "#current_resource" do
    let(:current_resource) { provider.tap(&:load_current_resource).current_resource }

    context "a cluster exists" do
      before { stub_request(:get, "localhost:8091/pools/default").to_return(fixture("pools_default_exists.http")) }

      it { current_resource.should be_a_kind_of Chef::Resource::CouchbaseCluster }

      it "has the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "has the same id as the new resource" do
        current_resource.id.should == new_resource.id
      end

      it "populates the memory_quota_mb" do
        current_resource.memory_quota_mb.should == 256
      end
    end

    context "a cluster does not exist" do
      before { stub_request(:get, "localhost:8091/pools/default").to_return(fixture("pools_default_404.http")) }

      it { current_resource.should be_a_kind_of Chef::Resource::CouchbaseCluster }

      it "has the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "has the same id as the new resource" do
        current_resource.id.should == new_resource.id
      end

      it "does not populate the memory_quota_mb" do
        expect { current_resource.memory_quota_mb }.to raise_error
      end
    end
  end

  describe "#cluster_exists" do
    before { stub_request(:get, "localhost:8091/pools/default").to_return(fixture(fixture_name)) }
    subject { provider.tap(&:load_current_resource).cluster_exists }

    context "the cluster exists" do
      let(:fixture_name) { "pools_default_exists.http" }
      it { should be_true }
    end

    context "the cluster does not exist" do
      let(:fixture_name) { "pools_default_404.http" }
      it { should be_false }
    end
  end
end
