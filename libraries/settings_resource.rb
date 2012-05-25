require "chef/resource"

class Chef
  class Resource
    class CouchbaseSettings < Resource
      attribute :username, :kind_of => String, :default => "Administrator"
      attribute :password, :kind_of => String
      attribute :group, :kind_of => String, :name_attribute => true
      attribute :settings, :kind_of => Hash, :required => true

      def initialize(*)
        super
        @action = :modify
        @allowed_actions.push :modify
        @resource_name = :couchbase_settings
      end
    end
  end
end
