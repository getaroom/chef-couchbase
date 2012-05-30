require "chef/provider"
require "net/http"
require File.join(File.dirname(__FILE__), "client")

class Chef
  class Provider
    class CouchbaseNode < Provider
      include Couchbase::Client

      def load_current_resource
        @current_resource = Chef::Resource::CouchbaseNode.new @new_resource.name
        @current_resource.id @new_resource.id
        @current_resource.database_path node_database_path
      end

      def action_modify
        if @current_resource.database_path != @new_resource.database_path
          post "/nodes/#{@new_resource.id}/controller/settings", "path" => @new_resource.database_path
          @new_resource.updated_by_last_action true
          Chef::Log.info "#{@new_resource} modified"
        end
      end

      private

      def node_database_path
        node_data["storage"]["hdd"][0]["path"]
      end

      def node_data
        @node_data ||= begin
          response = get "/nodes/#{@new_resource.id}"
          Chef::Log.error response.body unless response.kind_of?(Net::HTTPSuccess) || response.body.empty?
          response.value
          JSONCompat.from_json response.body
        end
      end
    end
  end
end
