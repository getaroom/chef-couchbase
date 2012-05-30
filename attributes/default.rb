package_machine = node['kernel']['machine'] == "x86_64" ? "x86_64" : "x86"

case node['platform']
when "debian", "ubuntu"
  package_ext = "deb"
when "redhat", "centos", "scientific", "amazon"
  package_ext = "rpm"
end

default['couchbase']['edition'] = "community"
default['couchbase']['version'] = "1.8.0"

default['couchbase']['package_file'] = "couchbase-server-#{node['couchbase']['edition']}_#{package_machine}_#{node['couchbase']['version']}.#{package_ext}"
default['couchbase']['package_base_url'] = "http://packages.couchbase.com/releases/#{node['couchbase']['version']}"
default['couchbase']['package_full_url'] = "#{node['couchbase']['package_base_url']}/#{node['couchbase']['package_file']}"

default['couchbase']['database_path'] = "/opt/couchbase/var/lib/couchbase/data"
default['couchbase']['log_dir'] = "/opt/couchbase/var/lib/couchbase/logs"

default['couchbase']['username'] = "Administrator"
default['couchbase']['password'] = ""

default['couchbase']['memory_quota_mb'] = Couchbase::MaxMemoryQuotaCalculator.from_node(node).in_megabytes
