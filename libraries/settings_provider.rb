require "chef/provider"
require File.join(File.dirname(__FILE__), "client")

class Chef
  class Provider
    class CouchbaseSettings < Provider
      include Couchbase::Client

      def load_current_resource
        @current_resource = Resource::CouchbaseSettings.new @new_resource.name
        @current_resource.group @new_resource.group
        @current_resource.settings settings_data
      end

      def action_modify
        unless settings_match?
          post "/settings/#{@new_resource.group}", @new_resource.settings
          @new_resource.updated_by_last_action true
          Chef::Log.info "#{@new_resource} modified"
        end
      end

      private

      def settings_match?
        @new_resource.settings.all? { |key, value| @current_resource.settings[key.to_s] == value }
      end

      def settings_data
        @settings_data ||= begin
          response = get "/settings/#{@new_resource.group}"
          Chef::Log.error response.body unless response.kind_of?(Net::HTTPSuccess) || response.body.to_s.empty?
          response.value
          JSONCompat.from_json response.body
        end
      end
    end
  end
end
