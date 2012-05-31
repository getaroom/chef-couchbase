require "spec_helper"
require "bucket_provider"
require "bucket_resource"

describe Chef::Provider::CouchbaseBucket do
  let(:provider) { described_class.new new_resource, stub("run_context") }
  let(:base_uri) { "#{new_resource.username}:#{new_resource.password}@localhost:8091" }
  let(:bucket_name) { "default" }
  let(:new_replicas) { 1 }

  let :new_resource do
    stub({
      :name => "mah_bukkit",
      :bucket_name => bucket_name,
      :username => "Administrator",
      :password => "password",
      :memory_quota_mb => 100,
      :replicas => new_replicas,
      :updated_by_last_action => nil,
    })
  end

  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Provider }
  end

  describe "#current_resource" do
    let(:current_resource) { provider.tap(&:load_current_resource).current_resource }

    context "when the bucket exists" do
      before do
        stub_request(:get, "#{base_uri}/pools/default/buckets/#{new_resource.bucket_name}").
        to_return(fixture("pools_default_buckets_default_exists.http"))
      end

      it { current_resource.should be_a_kind_of Chef::Resource::CouchbaseBucket }

      it "should have the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "has the same bucket_name as the new resource" do
        current_resource.bucket_name.should == new_resource.bucket_name
      end

      it "populates exists with true" do
        current_resource.exists.should be_true
      end

      it "populates the memory_quota_mb" do
        current_resource.memory_quota_mb.should == 128
      end

      it "populates the replicas" do
        current_resource.replicas.should == 2
      end
    end

    context "when another bucket exists" do
      let(:bucket_name) { "nondefault" }

      before do
        stub_request(:get, "#{base_uri}/pools/default/buckets/#{new_resource.bucket_name}").
        to_return(fixture("pools_default_buckets_nondefault_exists.http"))
      end

      it { current_resource.should be_a_kind_of Chef::Resource::CouchbaseBucket }

      it "should have the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "has the same bucket_name as the new resource" do
        current_resource.bucket_name.should == new_resource.bucket_name
      end

      it "populates exists with true" do
        current_resource.exists.should be_true
      end

      it "populates the memory_quota_mb" do
        current_resource.memory_quota_mb.should == 512
      end

      it "populates the replicas" do
        current_resource.replicas.should == 0
      end
    end

    context "when the bucket does not exist" do
      before do
        stub_request(:get, "#{base_uri}/pools/default/buckets/#{new_resource.bucket_name}").
        to_return(fixture("pools_default_buckets_default_404.http"))
      end

      it { current_resource.should be_a_kind_of Chef::Resource::CouchbaseBucket }

      it "should have the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "has the same bucket_name as the new resource" do
        current_resource.bucket_name.should == new_resource.bucket_name
      end

      it "populates exists with false" do
        current_resource.exists.should be_false
      end

      it "should not populate memory_quota_mb" do
        expect { current_resource.memory_quota_mb }.to raise_error Chef::Exceptions::ValidationFailed
      end
    end
  end

  describe "#load_current_resource" do
    context "authorization error" do
      before do
        stub_request(:get, "#{base_uri}/pools/default/buckets/default").
        to_return(fixture("pools_default_buckets_default_401.http"))
      end

      it { expect { provider.load_current_resource }.to raise_error(Net::HTTPExceptions) }
    end
  end

  describe "#action_create" do
    before { provider.current_resource = current_resource }
    subject { provider.action_create }
    let(:current_memory_quota_mb) { new_resource.memory_quota_mb }
    let(:current_replicas) { new_resource.replicas || 0 }

    let :current_resource do
      stub({
        :name => new_resource.name,
        :bucket_name => new_resource.bucket_name,
        :exists => bucket_exists,
        :memory_quota_mb => current_memory_quota_mb,
        :replicas => current_replicas,
      })
    end

    context "when the bucket does not exist" do
      let(:bucket_exists) { false }
      let!(:request) { stub_request(:post, "#{base_uri}/pools/default/buckets") }

      context "with a default configuration" do
        it "POSTs to the Management REST API to create the bucket" do
          provider.action_create
          request.with(:body => hash_including({
            "authType" => "sasl",
            "saslPassword" => "",
            "bucketType" => "membase",
            "name" => new_resource.bucket_name,
            "ramQuotaMB" => new_resource.memory_quota_mb.to_s,
            "replicaNumber" => new_resource.replicas.to_s,
          })).should have_been_made.once
        end

        it "updates the new resource" do
          new_resource.should_receive(:updated_by_last_action).with(true)
          provider.action_create
        end

        it "logs the creation" do
          Chef::Log.should_receive(:info).with(/created/)
          provider.action_create
        end
      end

      context "and replicas are set to false" do
        let(:new_replicas) { false }

        it "POSTs replicaNumber=0 to the Management REST API" do
          provider.action_create
          request.with(:body => hash_including("replicaNumber" => "0")).should have_been_made.once
        end
      end
    end

    context "when the bucket exists" do
      let(:bucket_exists) { true }
      let!(:request) { stub_request(:post, "#{base_uri}/pools/default/buckets/#{new_resource.bucket_name}") }

      context "when the bucket configuration exactly matches" do
        it_should_behave_like "a no op provider action"
      end

      context "when the memory quota does not match" do
        let(:current_memory_quota_mb) { new_resource.memory_quota_mb + 1 }

        it "POSTs to the Management REST API to modify the bucket" do
          provider.action_create
          request.with(:body => hash_including({
            "ramQuotaMB" => new_resource.memory_quota_mb.to_s,
          })).should have_been_made.once
        end

        it "updates the new resource" do
          new_resource.should_receive(:updated_by_last_action).with(true)
          provider.action_create
        end

        it "logs the modification" do
          Chef::Log.should_receive(:info).with(/memory_quota_mb changed to #{new_resource.memory_quota_mb}/)
          provider.action_create
        end
      end
    end

    context "Couchbase fails the request" do
      let(:bucket_exists) { false }

      before do
        Chef::Log.stub(:error)
        stub_request(:post, "#{base_uri}/pools/default/buckets").to_return(fixture("pools_default_buckets_400.http"))
      end

      it { expect { provider.action_create }.to raise_error(Net::HTTPExceptions) }

      it "logs the error" do
        Chef::Log.should_receive(:error).with(/invalid authType/)
        provider.action_create rescue nil
      end
    end
  end
end
