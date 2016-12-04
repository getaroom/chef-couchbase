package_machine = node['kernel']['machine'] == "x86_64" ? "x86_64" : "x86"

default['couchbase']['moxi']['version'] = "1.8.1"

case platform
when "ubuntu", "debian"
  default['couchbase']['moxi']['package_file'] = "moxi-server_#{package_machine}_#{node['couchbase']['moxi']['version']}.deb"
when "redhat", "centos", "scientific", "amazon", "fedora"
  default['couchbase']['moxi']['package_file'] = "moxi-server_#{package_machine}_#{node['couchbase']['moxi']['version']}.rpm"
else
  Chef::Log.error("Moxi Server is not supported on #{platform}")
end

default['couchbase']['moxi']['package_base_url'] = "http://packages.couchbase.com/releases/#{node['couchbase']['moxi']['version']}"
default['couchbase']['moxi']['package_full_url'] = "#{node['couchbase']['moxi']['package_base_url']}/#{node['couchbase']['moxi']['package_file']}"

default['couchbase']['moxi']['cluster_server'] = 'couchbase01'
default['couchbase']['moxi']['cluster_rest_url'] = "http://#{node['couchbase']['moxi']['cluster_server']}:8091/pools/default/bucketsStreaming/default"
