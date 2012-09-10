include_recipe "couchbase::server"

couchbase_bucket "default" do
  memory_quota_mb 100

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end

couchbase_bucket "memcached" do
  memory_quota_mb 100
  type "memcached"

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end

couchbase_bucket "modified mb creation" do
  bucket "modified_mb"
  type "couchbase"
  memory_quota_mb 100
  replicas false

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end

couchbase_bucket "modified % creation" do
  bucket "modified_percent"
  type "couchbase"
  memory_quota_percent 0.2

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end

ruby_block "wait for bucket creation, which is asynchronous" do
  block do
    sleep 2
  end
end

couchbase_bucket "modified mb modification" do
  bucket "modified_mb"
  type "couchbase"
  memory_quota_mb 125
  replicas 2

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end

couchbase_bucket "modified % modification" do
  bucket "modified_percent"
  type "couchbase"
  memory_quota_percent 0.3

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end
