#
# Cookbook Name:: couchbase
# Recipe:: server
#
# Copyright 2012, getaroom
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

remote_file File.join(Chef::Config[:file_cache_path], node['couchbase']['server']['package_file']) do
  source node['couchbase']['server']['package_full_url']
  action :create_if_missing
end

case node['platform']
when "debian", "ubuntu"
  dpkg_package File.join(Chef::Config[:file_cache_path], node['couchbase']['server']['package_file'])
when "redhat", "centos", "scientific", "amazon", "fedora"
  rpm_package File.join(Chef::Config[:file_cache_path], node['couchbase']['server']['package_file'])
when "windows"

  template "#{Chef::Config[:file_cache_path]}/setup.iss" do
    source "setup.iss.erb"
    action :create
  end

  windows_package "Couchbase Server" do
    source File.join(Chef::Config[:file_cache_path], node['couchbase']['server']['package_file'])
    options "/s"
    installer_type :custom
    action :install
  end
end

service "couchbase-server" do
  supports :restart => true, :status => true
  action [:enable, :start]
end

directory node['couchbase']['server']['log_dir'] do
  owner "couchbase"
  group "couchbase"
  mode 0755
  recursive true
end

ruby_block "rewrite_couchbase_log_dir_config" do
  log_dir_line = %{{error_logger_mf_dir, "#{node['couchbase']['server']['log_dir']}"}.}

  block do
    file = Chef::Util::FileEdit.new("/opt/couchbase/etc/couchbase/static_config")
    file.search_file_replace_line(/error_logger_mf_dir/, log_dir_line)
    file.write_file
  end

  notifies :restart, "service[couchbase-server]"
  not_if "grep '#{log_dir_line}' /opt/couchbase/etc/couchbase/static_config"
end

directory node['couchbase']['server']['database_path'] do
  owner "couchbase"
  group "couchbase"
  mode 0755
  recursive true
end

couchbase_node "self" do
  database_path node['couchbase']['server']['database_path']

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end

couchbase_cluster "default" do
  memory_quota_mb node['couchbase']['server']['memory_quota_mb']

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end

couchbase_settings "web" do
  settings({
    "username" => node['couchbase']['server']['username'],
    "password" => node['couchbase']['server']['password'],
    "port" => 8091,
  })

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end
