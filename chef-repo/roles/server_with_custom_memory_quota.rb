name "server_with_custom_memory_quota"
description "Test for server recipe"
run_list "recipe[couchbase::server]", "recipe[minitest-handler]"

default_attributes({
  "couchbase" => {
    "memory_quota_mb" => 257,
    "password" => "password",
  },
})
