require "spec_helper"
require "node_resource"
require "node_provider"

describe Chef::Provider::CouchbaseNode do
  let(:provider) { described_class.new(new_resource, stub("run_context")) }
  let(:new_resource) { stub(:name => "self") }

  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Provider }
  end

  describe "#current_resource" do
    let(:current_resource) { provider.load_current_resource; provider.current_resource }

    context "for the local node" do
      before { stub_request(:get, "localhost:8091/nodes/self").to_return(fixture("nodes_self_mnt.http")) }

      it { current_resource.should be_a_kind_of Chef::Resource::CouchbaseNode }

      it "has the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "populates the database_path" do
        current_resource.database_path.should == "/mnt/couchbase-server/data"
      end
    end

    context "for a remote node" do
      let(:new_resource) { stub(:name => "10.0.1.20") }
      before { stub_request(:get, "localhost:8091/nodes/10.0.1.20").to_return(fixture("nodes_self_opt.http")) }

      it "has the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "populates the database_path" do
        current_resource.database_path.should == "/opt/couchbase/var/lib/couchbase/data"
      end
    end
  end

  describe "#action_configure" do
    pending "needs resource"
  end
end
