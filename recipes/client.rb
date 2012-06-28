#
# Cookbook Name:: couchbase
# Recipe:: client
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

package_machine = node['kernel']['machine'] == "i386" ? "i386" : "amd64"

%w(libvbucket libcouchbase).each do |lib|
  %w(1 -dev).each do |package_suffix|
    package_file = "#{lib}#{package_suffix}_#{node['couchbase'][lib]['version']}_#{package_machine}.deb"

    remote_file File.join(Chef::Config[:file_cache_path], package_file) do
      source "#{node['couchbase'][lib]['package_base_url']}/#{package_file}"
      action :create_if_missing
    end

    dpkg_package File.join(Chef::Config[:file_cache_path], package_file)
  end
end
