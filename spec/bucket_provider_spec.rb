require "spec_helper"
require "bucket_provider"
require "bucket_resource"

describe Chef::Provider::CouchbaseBucket do
  let(:provider) { described_class.new new_resource, stub("run_context") }
  let(:base_uri) { "#{new_resource.username}:#{new_resource.password}@localhost:8091" }
  let(:bucket_name) { "default" }

  let :new_resource do
    stub({
      :name => "mah_bukkit",
      :bucket_name => bucket_name,
      :username => "Administrator",
      :password => "password",
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
end
