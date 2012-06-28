codename = %w(oneiric lucid).include?(node['lsb']['codename']) ? node['lsb']['codename'] : "oneiric"

default['couchbase']['libcouchbase']['version'] = "1.0.4-1"
default['couchbase']['libvbucket']['version'] = "1.8.0.4-1"

default['couchbase']['libcouchbase']['package_base_url'] = "http://packages.couchbase.com/ubuntu/pool/#{codename}/main/libc/libcouchbase"
default['couchbase']['libvbucket']['package_base_url'] = "http://packages.couchbase.com/ubuntu/pool/#{codename}/main/libv/libvbucket"
