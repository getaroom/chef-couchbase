describe_recipe "couchbase::moxi" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "moxi-server service" do
    let(:moxi_server) { service "moxi-server" }

    it "starts on boot" do
      moxi_server.must_be_enabled
    end

    it "is running as a daemon" do
      moxi_server.must_be_running
    end
  end

end
