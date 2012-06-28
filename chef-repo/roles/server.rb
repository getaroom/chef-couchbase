name "server"
description "Tests for Couchbase Server"

run_list(
  "recipe[couchbase::server]",
  "recipe[couchbase::test_buckets]",
  "recipe[couchbase::apps]",
)

default_attributes({
  "couchbase" => {
    "server" => {
      "password" => "password",
    },
  },
})
