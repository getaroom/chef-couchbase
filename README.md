DESCRIPTION
===========

Installs and configures Couchbase.

REQUIREMENTS
============

Platform
--------

Tested on Ubuntu 12.04.

ATTRIBUTES
==========

* `node['couchbase']['edition']`         - The edition of Couchbase to install, "community" or "enterprise"
* `node['couchbase']['version']`         - The version of Couchbase to install
* `node['couchbase']['package_file]`     - The package file to download and install
* `node['couchbase']['package_base_url]` - The url path to download the package file from
* `node['couchbase']['package_full_url]` - The full url to the package file to download and install
* `node['couchbase']['database_path']`   - The directory Couchbase should persist data to
* `node['couchbase']['log_dir']`         - The directory Couchbase should log to
* `node['couchbase']['memory_quota_mb']` - The per server RAM quota for the entire cluster in megabytes
                                           defaults to Couchbase's maximum allowed value

RECIPES
=======

server
------

Installs the couchbase-server package and starts the couchbase-server service.

logrotate
---------

Configures log rotation for couchbase-server.

RESOURCES/PROVIDERS
===================

couchbase_node
--------------

### Actions

* `:modify` - **Default** Modify the configuration of the node

### Attribute Parameters

* `id` - The id of the Couchbase node, typically "self"
* `database_path` - The directory the Couchbase node should persist data to

### Examples

```ruby
couchbase_node "self" do
  database_path "/mnt/couchbase-server/data"
end
```

couchbase_cluster
-----------------

### Actions

* `:create_if_missing` - **Default** Create a cluster/pool only if it doesn't exist yet

### Attribute Parameters

* `id` - The id of the Couchbase cluster, typically "default"
* `memory_quota_mb` - The per server RAM quota for the entire cluster in megabytes

### Examples

```ruby
couchbase_cluster "default" do
  memory_quota_mb 256
end
```

LICENSE AND AUTHOR
==================

Author:: Chris Griego (<cgriego@getaroom.com>)
Author:: Morgan Nelson (<mnelson@getaroom.com>)

Copyright 2012, getaroom

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
