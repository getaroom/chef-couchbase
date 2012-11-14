couchbase_bucket "default" do
  memory_quota_mb 100

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end
