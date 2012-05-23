require "chef/provider"
require "net/http"

class Chef
  class Provider
    class CouchbaseNode < Provider
      def load_current_resource
        @current_resource = Chef::Resource::CouchbaseNode.new(@new_resource.name)
        @current_resource.database_path node_data["storage"]["hdd"][0]["path"]
      end

      def action_modify
        if @current_resource.database_path != @new_resource.database_path
          uri = URI("http://localhost:8091/nodes/#{@new_resource.name}/controller/settings")
          Net::HTTP.post_form(uri, "path" => @new_resource.database_path).value
          @new_resource.updated_by_last_action(true)
          Chef::Log.info "#{@new_resource} modified"
        end
      end

      private

      def node_data
        @node_data ||= JSONCompat.from_json Net::HTTP.get("localhost", "/nodes/#{@new_resource.name}", 8091)
      end
    end
  end
end
