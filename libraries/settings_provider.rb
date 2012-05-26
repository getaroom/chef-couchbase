require "chef/provider"

class Chef
  class Provider
    class CouchbaseSettings < Provider
      def load_current_resource
        @current_resource = Resource::CouchbaseSettings.new @new_resource.name
        @current_resource.group @new_resource.group
        @current_resource.settings settings_data
      end

      def action_modify
        unless settings_match?
          response = Net::HTTP.post_form(uri, @new_resource.settings)
          Chef::Log.error response.body unless response.kind_of? Net::HTTPSuccess
          response.value
          @new_resource.updated_by_last_action true
          Chef::Log.info "#{@new_resource} modified"
        end
      end

      private

      def settings_match?
        @new_resource.settings.all? { |key, value| @current_resource.settings[key.to_s] == value }
      end

      def uri
        @uri ||= URI.parse "http://#{@new_resource.username}:#{@new_resource.password}@localhost:8091/settings/#{@new_resource.group}"
      end

      def settings_data
        @settings_data ||= begin
          response = Net::HTTP.start(uri.host, uri.port) do |http|
            request = Net::HTTP::Get.new uri.path
            request.basic_auth uri.user, uri.password
            http.request request
          end

          response.value
          JSONCompat.from_json response.body
        end
      end
    end
  end
end
