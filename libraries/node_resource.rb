require "chef/resource"

class Chef
  class Resource
    class CouchbaseNode < Resource
      attribute :id, :kind_of => String, :name_attribute => true
      attribute :database_path, :kind_of => String, :default => "/opt/couchbase/var/lib/couchbase/data"

      def initialize(*)
        super
        @action = :modify
        @allowed_actions.push(:modify)
        @resource_name = :couchbase_node
      end
    end
  end
end
