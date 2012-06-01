name "server"
description "Tests for Couchbase server"

run_list(
  "recipe[couchbase::server]",
  "recipe[couchbase::test_buckets]",
  "recipe[couchbase::apps]",
  "recipe[minitest-handler]",
)

default_attributes({
  "couchbase" => {
    "password" => "password",
  },
})
