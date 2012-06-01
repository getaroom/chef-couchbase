require "chef/provider"
require File.join(File.dirname(__FILE__), "client")

class Chef
  class Provider
    class CouchbaseCluster < Provider
      include Couchbase::Client

      def load_current_resource
        @current_resource = Resource::CouchbaseCluster.new @new_resource.name
        @current_resource.cluster @new_resource.cluster
        @current_resource.exists !!pool_data
        @current_resource.memory_quota_mb pool_memory_quota_mb if @current_resource.exists
      end

      def action_create_if_missing
        unless @current_resource.exists
          post "/pools/#{@new_resource.cluster}", "memoryQuota" => @new_resource.memory_quota_mb
          @new_resource.updated_by_last_action true
          Chef::Log.info "#{@new_resource} created"
        end
      end

      private

      def pool_memory_quota_mb
        pool_data["storageTotals"]["ram"]["quotaTotal"] / 1024 / 1024
      end

      def pool_data
        return @pool_data if instance_variable_defined? "@pool_data"

        @pool_data ||= begin
          response = get "/pools/#{@new_resource.cluster}"
          response.error! unless response.kind_of?(Net::HTTPSuccess) || response.kind_of?(Net::HTTPNotFound)
          JSONCompat.from_json response.body if response.kind_of? Net::HTTPSuccess
        end
      end
    end
  end
end
