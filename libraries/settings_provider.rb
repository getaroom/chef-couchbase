require "chef/provider"

class Chef
  class Provider
    class CouchbaseSettings < Provider
      def load_current_resource
        @current_resource = Resource::CouchbaseSettings.new(@new_resource.name)
        @current_resource.group @new_resource.group
        @current_resource.settings settings_data
      end

      private

      def settings_data
        return @settings_data if instance_variable_defined? "@settings_data"

        @settings_data ||= begin
          host = "#{@new_resource.username}:#{@new_resource.password}@localhost"
          response = Net::HTTP.get_response(host, "/settings/#{@new_resource.group}", 8091)
          response.value
          JSONCompat.from_json response.body
        end
      end
    end
  end
end
