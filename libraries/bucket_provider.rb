require "chef/provider"
require File.join(File.dirname(__FILE__), "client")

class Chef
  class Provider
    class CouchbaseBucket < Provider
      include Couchbase::Client

      def load_current_resource
        @current_resource = Resource::CouchbaseBucket.new @new_resource.name
        @current_resource.bucket_name @new_resource.bucket_name
        @current_resource.exists !!bucket_data

        if @current_resource.exists
          @current_resource.memory_quota_mb bucket_memory_quota_mb
          @current_resource.replicas bucket_replicas
        end
      end

      private

      def bucket_memory_quota_mb
        bucket_data["quota"]["rawRAM"] / 1024 / 1024
      end

      def bucket_replicas
        bucket_data["replicaNumber"]
      end

      def bucket_data
        return @bucket_data if instance_variable_defined? "@bucket_data"

        @bucket_data ||= begin
          response = get "/pools/default/buckets/#{@new_resource.bucket_name}"
          response.error! unless response.kind_of?(Net::HTTPSuccess) || response.kind_of?(Net::HTTPNotFound)
          JSONCompat.from_json response.body if response.kind_of?(Net::HTTPSuccess)
        end
      end
    end
  end
end
