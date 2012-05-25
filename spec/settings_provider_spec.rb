require "spec_helper"
require "settings_resource"
require "settings_provider"

describe Chef::Provider::CouchbaseSettings do
  let(:provider) { described_class.new(new_resource, stub("run_context")) }

  let :new_resource do
    stub({
      :name => "my settings",
      :group => group,
      :username => "Administrator",
      :password => "password",
    })
  end

  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Provider }
  end

  describe "#current_resource" do
    let(:current_resource) { provider.tap(&:load_current_resource).current_resource }

    context "web settings" do
      let(:group) { "web" }

      before do
        stub_request(:get, "#{new_resource.username}:#{new_resource.password}@localhost:8091/settings/web").
        to_return(fixture("settings_web_populated.http"))
      end

      it { current_resource.should be_a_kind_of Chef::Resource::CouchbaseSettings }

      it "has the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "has the same group as the new resource" do
        current_resource.group.should == new_resource.group
      end

      it "populates the settings" do
        current_resource.settings.should == {
          "username" => "Administrator",
          "password" => "password",
          "port" => 8091,
        }
      end
    end

    context "autoFailover settings" do
      let(:group) { "autoFailover" }

      before do
        stub_request(:get, "#{new_resource.username}:#{new_resource.password}@localhost:8091/settings/autoFailover").
        to_return(fixture("settings_auto_failover_disabled.http"))
      end

      it { current_resource.should be_a_kind_of Chef::Resource::CouchbaseSettings }

      it "has the same name as the new resource" do
        current_resource.name.should == new_resource.name
      end

      it "has the same group as the new resource" do
        current_resource.group.should == new_resource.group
      end

      it "populates the settings" do
        current_resource.settings.should == {
          "enabled" => false,
          "timeout" => 30,
          "count" => 0,
        }
      end
    end
  end

  describe "#load_current_resource" do
    context "request fails due to invalid credentials" do
      let(:group) { "web" }

      before do
        stub_request(:get, "#{new_resource.username}:#{new_resource.password}@localhost:8091/settings/web").
        to_return(fixture("settings_web_401.http"))
      end

      it { expect { provider.load_current_resource }.to raise_error(Net::HTTPExceptions) }
    end

    context "request fails due to unknown settings group" do
      let(:group) { "unknown" }

      before do
        stub_request(:get, "#{new_resource.username}:#{new_resource.password}@localhost:8091/settings/unknown").
        to_return(fixture("settings_unknown_404.http"))
      end

      it { expect { provider.load_current_resource }.to raise_error(Net::HTTPExceptions) }
    end
  end
end
