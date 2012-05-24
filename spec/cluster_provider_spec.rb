require "spec_helper"
require "cluster_provider"
require "cluster_resource"

describe Chef::Provider::CouchbaseCluster do
  let(:provider) { described_class.new(new_resource, stub("run_context")) }

  let :new_resource do
    stub({
      :name => "my new pool",
      :id => "default",
      :memory_quota_mb => 256,
      :updated_by_last_action => nil,
    })
  end

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

  describe "#action_create_if_missing" do
    let(:memory_quota_mb) { 256 }

    before do
      provider.current_resource = stub(:id => "default", :memory_quota_mb => memory_quota_mb)
      provider.cluster_exists = cluster_exists
    end

    context "cluster does not exist" do
      let(:cluster_exists) { false }

      let! :cluster_request do
        stub_request(:post, "localhost:8091/pools/default").with({
          :body => hash_including("memoryQuota" => new_resource.memory_quota_mb.to_s),
        })
      end

      it "POSTs to the Management REST API to create the cluster" do
        provider.action_create_if_missing
        cluster_request.should have_been_made.once
      end

      it "updates the new resource" do
        new_resource.should_receive(:updated_by_last_action).with(true)
        provider.action_create_if_missing
      end

      it "logs the modification" do
        Chef::Log.should_receive(:info).with(/created/)
        provider.action_create_if_missing
      end
    end

    context "Couchbase fails the request" do
      let(:cluster_exists) { false }

      let! :cluster_request do
        stub_request(:post, "localhost:8091/pools/default").to_return(fixture("pools_default_400.http"))
      end

      it { expect { provider.action_create_if_missing }.to raise_error(Net::HTTPExceptions) }
    end

    context "cluster exists but quotas don't match" do
      let(:cluster_exists) { true }
      let(:memory_quota_mb) { new_resource.memory_quota_mb * 2 }

      it "does not POST to the Management REST API" do
        provider.action_create_if_missing
        a_request(:any, /.*/).should_not have_been_made
      end

      it "does not update the new resource" do
        new_resource.should_not_receive(:updated_by_last_action)
        provider.action_create_if_missing
      end

      it "does not log" do
        Chef::Log.should_not_receive(:info).with(/created/)
        provider.action_create_if_missing
      end
    end
  end
end
