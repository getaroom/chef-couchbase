name "client"
description "Tests for Couchbase Client"

run_list(
  "recipe[couchbase::client]",
)
