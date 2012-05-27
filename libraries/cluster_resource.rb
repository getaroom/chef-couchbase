require "chef/resource"

class Chef
  class Resource
    class CouchbaseCluster < Resource
      attribute :username, :kind_of => String, :default => "Administrator"
      attribute :password, :kind_of => String
      attribute :id, :kind_of => String, :name_attribute => true
      attribute :memory_quota_mb, :kind_of => Integer, :required => true, :callbacks => {
        "must be at least 256" => lambda { |quota| quota >= 256 }
      }

      def initialize(*)
        super
        @action = :create_if_missing
        @allowed_actions.push :create_if_missing
        @resource_name = :couchbase_cluster
      end
    end
  end
end
