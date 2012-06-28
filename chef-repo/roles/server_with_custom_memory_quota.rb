name "server_with_custom_memory_quota"
description "Test for server recipe"

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
