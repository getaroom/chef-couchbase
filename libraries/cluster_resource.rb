require "chef/resource"

class Chef
  class Resource
    class CouchbaseCluster < Resource
      attribute :id, :kind_of => String, :name_attribute => true
      attribute :memory_quota_mb, :kind_of => Integer, :required => true, :callbacks => {
        "must be at least 256" => lambda { |quota| quota >= 256 }
      }

      def initialize(name, run_context=nil)
        super
        @action = :create_if_missing
        @allowed_actions.push :create_if_missing
        @provider = Provider::CouchbaseCluster
        @resource_name = :couchbase_cluster
      end
    end
  end
end
