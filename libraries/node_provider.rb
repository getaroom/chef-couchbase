require "chef/provider"
require "net/http"

class Chef
  class Provider
    class CouchbaseNode < Provider
      def load_current_resource
        @current_resource = Chef::Resource::CouchbaseNode.new(@new_resource.name)
        @current_resource.database_path node_data["storage"]["hdd"][0]["path"]
      end

      private

      def node_data
        @node_data ||= JSONCompat.from_json Net::HTTP.get("localhost", "/nodes/#{@new_resource.name}", 8091)
      end
    end
  end
end
