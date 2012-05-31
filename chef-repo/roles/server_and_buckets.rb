name "server_and_buckets"
description "Test for server recipe and bucket resource/provider"

run_list(
  "recipe[couchbase::server]",
  "recipe[couchbase::test_buckets]",
  "recipe[minitest-handler]",
)

default_attributes({
  "couchbase" => {
    "password" => "password",
  },
})
