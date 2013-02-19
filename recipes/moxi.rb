#
# Cookbook Name:: couchbase
# Recipe:: moxi
# Author:: Julian C. Dunn (<jdunn@secondmarket.com>)
#
# Copyright 2013, SecondMarket Labs, LLC.
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
# Mutually exclusive with the server recipe. If you have the server on this node you don't need moxi client.
unless (node['recipes'].include?("couchbase::server"))

  remote_file File.join(Chef::Config[:file_cache_path], node['couchbase']['moxi']['package_file']) do
    source node['couchbase']['moxi']['package_full_url']
    action :create_if_missing
  end

  case node['platform_family']
  when "debian"
    dpkg_package File.join(Chef::Config[:file_cache_path], node['couchbase']['moxi']['package_file'])
  when "rhel"
    rpm_package File.join(Chef::Config[:file_cache_path], node['couchbase']['moxi']['package_file'])
  end
  
  service "moxi-server" do
    supports :restart => true, :status => true
    action :enable
  end

  template "/opt/moxi/etc/moxi-cluster.cfg" do
    source "moxi-cluster.cfg.erb"
    owner 'moxi'
    group 'moxi'
    mode '00644'
    action :create
    notifies :restart, "service[moxi-server]"
  end

  service "moxi-server" do
    action :start
  end

end
