describe_recipe "couchbase::client" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "libcouchbase-dev" do
    it "is installed" do
      package("libcouchbase-dev").must_be_installed
    end

    it "installed the correct version" do
      package("libcouchbase-dev").must_have :version, node['couchbase']['libcouchbase']['version']
    end
  end

  describe "libvbucket-dev" do
    it "is installed" do
      package("libvbucket-dev").must_be_installed
    end

    it "installed the correct version" do
      package("libvbucket-dev").must_have :version, node['couchbase']['libvbucket']['version']
    end
  end
end
