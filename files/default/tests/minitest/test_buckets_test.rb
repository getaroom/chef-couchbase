describe_recipe "couchbase::test_buckets" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  MiniTest::Chef::Resources.register_resource :couchbase_bucket, :username, :password

  describe "a default bucket" do
    let :bucket do
      couchbase_bucket("default", {
        :username => node["couchbase"]["server"]["username"],
        :password => node["couchbase"]["server"]["password"],
      })
    end

    it "exists" do
      assert bucket.exists
    end

    it "is of type couchbase" do
      bucket.must_have :type, "couchbase"
    end

    it "has a 100MB quota" do
      bucket.must_have :memory_quota_mb, 100
    end

    it "has 1 replica" do
      bucket.must_have :replicas, 1
    end
  end

  describe "a memcached bucket" do
    let :bucket do
      couchbase_bucket("memcached", {
        :username => node["couchbase"]["server"]["username"],
        :password => node["couchbase"]["server"]["password"],
      })
    end

    it "exists" do
      assert bucket.exists
    end

    it "is of type memcached" do
      bucket.must_have :type, "memcached"
    end

    it "has a 100MB quota" do
      bucket.must_have :memory_quota_mb, 100
    end
  end

  describe "a modified bucket in MB" do
    let :bucket do
      couchbase_bucket("modified_mb", {
        :username => node["couchbase"]["server"]["username"],
        :password => node["couchbase"]["server"]["password"],
      })
    end

    it "exists" do
      assert bucket.exists
    end

    it "is of type couchbase" do
      bucket.must_have :type, "couchbase"
    end

    it "has a 125MB quota" do
      bucket.must_have :memory_quota_mb, 125
    end

    it "has 0 replicas" do
      bucket.must_have :replicas, 0
    end
  end

  describe "a modified bucket in %" do
    let :bucket do
      couchbase_bucket("modified_percent", {
        :username => node["couchbase"]["server"]["username"],
        :password => node["couchbase"]["server"]["password"],
      })
    end

    it "exists" do
      assert bucket.exists
    end

    it "is of type couchbase" do
      bucket.must_have :type, "couchbase"
    end

    it "has a 12.5% quota" do
      bucket.must_have :memory_quota_mb, (node["couchbase"]["server"]["memory_quota_mb"] * 0.125).to_i
    end
  end
end
