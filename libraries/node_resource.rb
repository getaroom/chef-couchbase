require "chef/resource"

class Chef
  class Resource
    class CouchbaseNode < Resource
      attribute :database_path, :kind_of => String, :default => "/opt/couchbase/var/lib/couchbase/data"

      def initialize(name, run_context=nil)
        super
        @action = :update
        @allowed_actions.push(:update)
        @provider = Provider::CouchbaseNode
        @resource_name = :couchbase_node
      end
    end
  end
end
