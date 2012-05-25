require "chef/provider"

class Chef
  class Provider
    class CouchbaseCluster < Provider
      attr_accessor :cluster_exists

      def load_current_resource
        @current_resource = Resource::CouchbaseCluster.new(@new_resource.name)
        @current_resource.id @new_resource.id

        @cluster_exists = pool_data

        if @cluster_exists
          @current_resource.memory_quota_mb pool_memory_quota_mb
        end
      end

      def action_create_if_missing
        unless @cluster_exists
          uri = URI("http://localhost:8091/pools/#{@new_resource.id}")
          Net::HTTP.post_form(uri, "memoryQuota" => @new_resource.memory_quota_mb).value
          @new_resource.updated_by_last_action true
          Chef::Log.info("#{@new_resource} created")
        end
      end

      private

      def pool_memory_quota_mb
        pool_data["storageTotals"]["ram"]["quotaTotal"] / 1024 / 1024
      end

      def pool_data
        return @pool_data if instance_variable_defined? "@pool_data"

        @pool_data ||= begin
          response = Net::HTTP.get_response("localhost", "/pools/#{@new_resource.id}", 8091)
          JSONCompat.from_json response.body if response.kind_of?(Net::HTTPSuccess)
        end
      end
    end
  end
end
