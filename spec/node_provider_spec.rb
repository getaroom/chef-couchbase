require "spec_helper"
require "node_resource"
require "node_provider"

describe Chef::Provider::CouchbaseNode do
  let(:provider) { described_class.new(new_resource, stub("run_context")) }
  let(:new_resource) { stub(:name => "my node", :id => "self") }

  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Provider }
  end

  describe "#current_resource" do
    let(:current_resource) { provider.tap(&:load_current_resource).current_resource }

    context "for the local node" do
      before { stub_request(:get, "localhost:8091/nodes/self").to_return(fixture("nodes_self_mnt.http")) }

      it { current_resource.should be_a_kind_of Chef::Resource::CouchbaseNode }

      it "has the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "has the same id as the new resource" do
        current_resource.id.should == new_resource.id
      end

      it "populates the database_path" do
        current_resource.database_path.should == "/mnt/couchbase-server/data"
      end
    end

    context "for a remote node" do
      let(:new_resource) { stub(:name => "my node", :id => "10.0.1.20") }
      before { stub_request(:get, "localhost:8091/nodes/10.0.1.20").to_return(fixture("nodes_self_opt.http")) }

      it "has the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "has the same id as the new resource" do
        current_resource.id.should == new_resource.id
      end

      it "populates the database_path" do
        current_resource.database_path.should == "/opt/couchbase/var/lib/couchbase/data"
      end
    end
  end

  describe "#action_modify" do
    before { provider.current_resource = current_resource }

    context "database path does not match" do
      shared_examples "modify couchbase node" do
        let :current_resource do
          stub({
            :name => "my node",
            :id => id,
            :database_path => "/opt/couchbase/var/lib/couchbase/data",
          })
        end

        let :new_resource do
          stub({
            :name => "my node",
            :id => id,
            :database_path => "/mnt/couchbase-server/data/#{SecureRandom.hex(8)}",
            :updated_by_last_action => nil,
          })
        end

        let! :node_request do
          stub_request(:post, "localhost:8091/nodes/#{id}/controller/settings").with({
            :body => hash_including("path" => new_resource.database_path),
          })
        end

        it "POSTs to the Management REST API to update the database path" do
          provider.action_modify
          node_request.should have_been_made.once
        end

        it "updates the new resource" do
          new_resource.should_receive(:updated_by_last_action).with(true)
          provider.action_modify
        end

        it "logs the modification" do
          Chef::Log.should_receive(:info).with(/modified/)
          provider.action_modify
        end
      end

      context "addressing the node as self" do
        let(:id) { "self" }
        include_examples "modify couchbase node"
      end

      context "addressing the node by hostname" do
        let(:id) { "10.0.1.20" }
        include_examples "modify couchbase node"
      end
    end

    context "database path matches" do
      let :new_resource do
        stub({
          :name => "my node",
          :id => "self",
          :database_path => "/opt/couchbase/var/lib/couchbase/data",
        })
      end

      let :current_resource do
        stub({
          :name => "my node",
          :id => "self",
          :database_path => "/opt/couchbase/var/lib/couchbase/data",
        })
      end

      it "does not POST to the Management REST API" do
        provider.action_modify
        a_request(:any, /.*/).should_not have_been_made
      end

      it "does not update the new resource" do
        new_resource.should_not_receive(:updated_by_last_action)
        provider.action_modify
      end

      it "does not log" do
        Chef::Log.should_not_receive(:info).with(/modified/)
        provider.action_modify
      end
    end

    context "Couchbase fails the request" do
      let :new_resource do
        stub(:name => "my node", :id => "self", :database_path => "/mnt/couchbase-server/data")
      end

      let :current_resource do
        stub(:name => "my node", :id => "self", :database_path => "/opt/couchbase/var/lib/couchbase/data")
      end

      let! :node_request do
        stub_request(:post, "localhost:8091/nodes/self/controller/settings").with({
          :body => hash_including("path" => new_resource.database_path),
        }).to_return(fixture("nodes_self_controller_settings_400.http"))
      end

      it { expect { provider.action_modify }.to raise_error(Net::HTTPExceptions) }
    end
  end
end
