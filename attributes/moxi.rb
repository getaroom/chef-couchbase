#
# Cookbook Name:: couchbase
# Attributes:: moxi
#
# Author:: Julian C. Dunn (<jdunn@opscode.com>)
# Copyright (C) 2012, SecondMarket Labs, LLC.
# Copyright (C) 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package_machine = node['kernel']['machine'] == "x86_64" ? "x86_64" : "x86"

default['couchbase']['moxi']['version'] = "2.5.0"

case node['platform_family']
when "debian"
  default['couchbase']['moxi']['package_file'] = "moxi-server_#{node['couchbase']['moxi']['version']}_#{package_machine}.deb"
when "rhel"
  default['couchbase']['moxi']['package_file'] = "moxi-server_#{node['couchbase']['moxi']['version']}_#{package_machine}.rpm"
else
  Chef::Log.error("Moxi Server is not supported on #{platform}")
end

default['couchbase']['moxi']['package_base_url'] = "http://packages.couchbase.com/releases/#{node['couchbase']['moxi']['version']}"
default['couchbase']['moxi']['package_full_url'] = "#{node['couchbase']['moxi']['package_base_url']}/#{node['couchbase']['moxi']['package_file']}"

default['couchbase']['moxi']['cluster_server'] = 'couchbase01'
default['couchbase']['moxi']['cluster_rest_url'] = "http://#{node['couchbase']['moxi']['cluster_server']}:8091/pools/default/bucketsStreaming/default"
