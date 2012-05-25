require "chef/provider"

class Chef
  class Provider
    class CouchbaseSettings < Provider
      def load_current_resource
        @current_resource = Resource::CouchbaseSettings.new(@new_resource.name)
        @current_resource.group @new_resource.group
        @current_resource.settings settings_data
      end

      def action_modify
        unless settings_match?
          uri = URI("http://#{host}:8091/settings/#{@new_resource.group}")
          Net::HTTP.post_form(uri, @new_resource.settings).value
          @new_resource.updated_by_last_action(true)
          Chef::Log.info("#{@new_resource} modified")
        end
      end

      private

      def settings_match?
        @new_resource.settings.all? { |key, value| @current_resource.settings[key.to_s] == value }
      end

      def host
        "#{@new_resource.username}:#{@new_resource.password}@localhost"
      end

      def settings_data
        return @settings_data if instance_variable_defined? "@settings_data"

        @settings_data ||= begin
          response = Net::HTTP.get_response(host, "/settings/#{@new_resource.group}", 8091)
          response.value
          JSONCompat.from_json response.body
        end
      end
    end
  end
end
