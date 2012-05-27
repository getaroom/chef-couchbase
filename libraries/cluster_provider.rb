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
          Net::HTTP.post_form(uri, "memoryQuota" => @new_resource.memory_quota_mb).value
          @new_resource.updated_by_last_action true
          Chef::Log.info("#{@new_resource} created")
        end
      end

      private

      def uri
        @uri ||= URI.parse "http://#{@new_resource.username}:#{@new_resource.password}@localhost:8091/pools/#{@new_resource.id}"
      end

      def pool_memory_quota_mb
        pool_data["storageTotals"]["ram"]["quotaTotal"] / 1024 / 1024
      end

      def pool_data
        return @pool_data if instance_variable_defined? "@pool_data"

        @pool_data ||= begin
          response = Net::HTTP.start(uri.host, uri.port) do |http|
            request = Net::HTTP::Get.new uri.path
            request.basic_auth uri.user, uri.password
            http.request request
          end

          JSONCompat.from_json response.body if response.kind_of?(Net::HTTPSuccess)
        end
      end
    end
  end
end
