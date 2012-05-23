describe_recipe "couchbase::server" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "couchbase-server service" do
    let(:couchbase_server) { service("couchbase-server") }

    it "starts on boot" do
      couchbase_server.must_be_enabled
    end

    it "is running as a daemon" do
      couchbase_server.must_be_running
    end
  end

  describe "log directory" do
    let(:log_dir) { directory(node['couchbase']['log_dir']) }

    it "exists" do
      log_dir.must_exist
    end

    it "is owned by couchbase" do
      log_dir.must_exist.with(:owner, "couchbase")
      log_dir.must_exist.with(:group, "couchbase")
    end
  end

  describe "static_config" do
    let(:static_config) { file("/opt/couchbase/etc/couchbase/static_config") }

    it "moves the log directory" do
      static_config.must_include %{{error_logger_mf_dir, "#{node['couchbase']['log_dir']}"}.}
      static_config.wont_match /error_logger_mf_dir.*error_logger_mf_dir/
    end
  end

  describe "log rotation" do
    let(:logrotate) { file("/etc/logrotate.d/couchbase-server") }

    it "exists" do
      logrotate.wont_exist
    end
  end
end
