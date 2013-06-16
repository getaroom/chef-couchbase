describe_recipe "couchbase::client" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "libcouchbase-dev" do
    it "is installed" do
      case node['platform_family']
      when "debian"
        package("libcouchbase-dev").must_be_installed
      when "rhel"
        package("libcouchbase-devel").must_be_installed
      end
    end

    it "installed the correct version" do
      case node['platform_family']
      when "debian"
        package("libcouchbase-dev").must_have :version, node['couchbase']['client']['version']
      when "rhel"
        package("libcouchbase-devel").must_be_installed
      end
    end
  end

  describe "libcouchbase2" do
    it "is installed" do
      package("libcouchbase2").must_be_installed
    end

    it "installed the correct version" do
      package("libcouchbase2").must_have :version, node['couchbase']['client']['version']
    end
  end
end
