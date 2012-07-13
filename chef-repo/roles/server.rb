name "server"
description "Tests for Couchbase Server"

run_list(
  "recipe[couchbase::server]",
  "recipe[couchbase::test_buckets]",
)

default_attributes({
  "couchbase" => {
    "server" => {
      "password" => "password",
    },
  },
})
