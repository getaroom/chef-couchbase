codename = %w(oneiric lucid).include?(node['lsb']['codename']) ? node['lsb']['codename'] : "oneiric"

default['couchbase']['libcouchbase']['version'] = "1.0.4-1"
default['couchbase']['libvbucket']['version'] = "1.8.0.4-1"

default['couchbase']['libcouchbase']['package_base_url'] = "http://packages.couchbase.com/ubuntu/pool/#{codename}/main/libc/libcouchbase"
default['couchbase']['libvbucket']['package_base_url'] = "http://packages.couchbase.com/ubuntu/pool/#{codename}/main/libv/libvbucket"

if node['platform_version'].to_f < 11.10
  default['couchbase']['client']['dependencies'] = ["libevent-1.4-2"]
else
  default['couchbase']['client']['dependencies'] = ["libevent-2.0-5"]
end
