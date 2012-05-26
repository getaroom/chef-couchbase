name "server"
description "Test for server recipe"
run_list "recipe[couchbase::server]", "recipe[minitest-handler]"
default_attributes "couchbase" => { "password" => "password" }
