describe_recipe "couchbase::test_buckets" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  MiniTest::Chef::Resources.register_resource :couchbase_bucket, :username, :password

  describe "a default bucket" do
    let :bucket do
      couchbase_bucket("default", {
        :username => node["couchbase"]["username"],
        :password => node["couchbase"]["password"],
      })
    end

    it "exists" do
      assert bucket.exists
    end

    it "has a 100MB quota" do
      bucket.must_have :memory_quota_mb, 100
    end

    it "has 1 replica" do
      bucket.must_have :replicas, 1
    end
  end

  describe "a modified bucket in MB" do
    let :bucket do
      couchbase_bucket("modified_mb", {
        :username => node["couchbase"]["username"],
        :password => node["couchbase"]["password"],
      })
    end

    it "exists" do
      assert bucket.exists
    end

    it "has a 150MB quota" do
      bucket.must_have :memory_quota_mb, 150
    end

    it "has 0 replicas" do
      bucket.must_have :replicas, 0
    end
  end

  describe "a modified bucket in %" do
    let :bucket do
      couchbase_bucket("modified_percent", {
        :username => node["couchbase"]["username"],
        :password => node["couchbase"]["password"],
      })
    end

    it "exists" do
      assert bucket.exists
    end

    it "has a 15% quota" do
      bucket.must_have :memory_quota_mb, (node["couchbase"]["memory_quota_mb"] * 0.15).to_i
    end
  end
end
