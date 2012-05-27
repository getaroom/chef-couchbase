require "chef/resource"
require File.join(File.dirname(__FILE__), "credentials_attributes")

class Chef
  class Resource
    class CouchbaseSettings < Resource
      include Couchbase::CredentialsAttributes

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
