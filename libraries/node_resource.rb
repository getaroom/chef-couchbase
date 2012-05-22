require "chef/resource"

class Chef
  class Resource
    class CouchbaseNode < Resource
      attribute :database_path, :kind_of => String, :default => "/opt/couchbase/var/lib/couchbase"

      def initialize(name, run_context=nil)
        super
        @action = :configure
        @allowed_actions.push(:configure)
        @provider = Provider::CouchbaseNode
        @resource_name = :couchbase_node
      end
    end
  end
end
