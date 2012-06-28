#
# Cookbook Name:: couchbase
# Recipe:: apps
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

search :apps do |app|
  if (app['couchbase_role'] & node.run_list.roles).any?
    app['couchbase_buckets'].each do |environment, bucket|
      couchbase_bucket bucket['bucket'] do
        type bucket['type'] if bucket['type']

        if bucket['memory_quota_mb']
          memory_quota_mb bucket['memory_quota_mb']
        else
          memory_quota_percent bucket['memory_quota_percent']
        end

        replicas bucket['replicas'] if bucket.has_key? 'replicas'

        username node['couchbase']['server']['username']
        password node['couchbase']['server']['password']
      end if environment.include? node.chef_environment
    end
  end
end
