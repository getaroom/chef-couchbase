require "chef/resource"

class Chef
  class Resource
    class CouchbaseNode < Resource
      def initialize(name, run_context=nil)
        super
        @allowed_actions.push(:configure)
        @action = :configure
        @provider = Provider::CouchbaseNode
      end
    end
  end
end
