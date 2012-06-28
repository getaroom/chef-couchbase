name "server_with_custom_memory_quota"
description "Tests for Couchbase Server with a custom memory quota"

run_list(
  "role[server]",
)

default_attributes({
  "couchbase" => {
    "server" => {
      "memory_quota_mb" => 1000,
    },
  },
})
