require "chef/resource"
require File.join(File.dirname(__FILE__), "credentials_attributes")

class Chef
  class Resource
    class CouchbaseBucket < Resource
      include Couchbase::CredentialsAttributes

      attribute :bucket, :kind_of => String, :name_attribute => true
      attribute :cluster, :kind_of => String, :default => "default"
      attribute :exists, :kind_of => [TrueClass, FalseClass], :required => true
      attribute :auth_type, :kind_of => String, :default => "sasl", :callbacks => {
        "must be either sasl or none" => lambda { |auth_type| %w(sasl none).include? auth_type },
      }

      attribute :proxy_port, :kind_of => Integer, :default => 11212

      attribute :memory_quota_mb, :kind_of => Integer, :callbacks => {
        "must be at least 100" => lambda { |quota| quota >= 100 },
      }

      attribute :memory_quota_percent, :kind_of => Numeric, :callbacks => {
        "must be a positive number" => lambda { |percent| percent > 0.0 },
        "must be less than or equal to 1.0" => lambda { |percent| percent <= 1.0 },
      }

      attribute :replicas, :kind_of => [Integer, FalseClass], :default => 1, :callbacks => {
        "must be a non-negative integer" => lambda { |replicas| !replicas || replicas > -1 },
      }

      attribute :type, :kind_of => String, :default => "couchbase", :callbacks => {
        "must be either couchbase or memcached" => lambda { |type| %w(couchbase memcached).include? type },
      }

      def initialize(*)
        super
        @action = :create
        @allowed_actions.push :create
        @resource_name = :couchbase_bucket
      end
    end
  end
end
