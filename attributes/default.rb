default['couchbase']['edition'] = "community"
default['couchbase']['version'] = "1.8.0"

default['couchbase']['database_path'] = "/opt/couchbase/var/lib/couchbase/data"
default['couchbase']['log_dir'] = "/opt/couchbase/var/lib/couchbase/logs"

default['couchbase']['memory_quota_mb'] = CouchbaseMaxMemoryQuotaCalculator.from_node(node).in_megabytes
