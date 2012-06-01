describe_recipe "couchbase::apps" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  MiniTest::Chef::Resources.register_resource :couchbase_bucket, :username, :password

  describe "the production default bucket" do
    let :bucket do
      couchbase_bucket("production_default", {
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

  describe "the production not replicated bucket" do
    let :bucket do
      couchbase_bucket("production_not_replicated", {
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

  describe "the production replicated bucket" do
    let :bucket do
      couchbase_bucket("production_replicated", {
        :username => node["couchbase"]["username"],
        :password => node["couchbase"]["password"],
      })
    end

    it "exists" do
      assert bucket.exists
    end

    it "has a 200MB quota" do
      bucket.must_have :memory_quota_mb, 200
    end

    it "has 2 replicas" do
      bucket.must_have :replicas, 2
    end
  end

  describe "the production percentage bucket" do
    let :bucket do
      couchbase_bucket("production_percent", {
        :username => node["couchbase"]["username"],
        :password => node["couchbase"]["password"],
      })
    end

    it "exists" do
      assert bucket.exists
    end

    it "has a 10% quota" do
      bucket.must_have :memory_quota_mb, (node["couchbase"]["memory_quota_mb"] * 0.1).to_i
    end

    it "has 0 replicas" do
      bucket.must_have :replicas, 0
    end
  end

  describe "the staging default bucket" do
    let :bucket do
      couchbase_bucket("staging_default", {
        :username => node["couchbase"]["username"],
        :password => node["couchbase"]["password"],
      })
    end

    it "does not exists" do
      refute bucket.exists
    end
  end
end
