#
# Cookbook Name:: couchbase
# Recipe:: test_buckets
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

couchbase_bucket "default" do
  memory_quota_mb 100

  username node['couchbase']['username']
  password node['couchbase']['password']
end

couchbase_bucket "modified creation" do
  bucket "modified"
  memory_quota_mb 100
  replicas false

  username node['couchbase']['username']
  password node['couchbase']['password']
end

ruby_block "wait for bucket creation, which is asynchronous" do
  block do
    sleep 2
  end
end

couchbase_bucket "modified modification" do
  bucket "modified"
  memory_quota_mb 150
  replicas 2

  username node['couchbase']['username']
  password node['couchbase']['password']
end
