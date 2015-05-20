module Couchbase
  module Client
    private

    def uri_from_path(path)
      URI.parse("http://localhost:8091#{path}")
    end

    def post(path, params)
      uri = uri_from_path(path)
      response = Net::HTTP.start uri.host, uri.port do |http|
        request = Net::HTTP::Post.new uri.path
        request.basic_auth @new_resource.username, @new_resource.password
        request.form_data = params
        http.request request
      end

      Chef::Log.error response.body unless response.kind_of? Net::HTTPSuccess
      response
    end

    def get(path)
      uri = uri_from_path(path)
      response = Net::HTTP.start uri.host, uri.port do |http|
        request = Net::HTTP::Get.new uri.path
        request.basic_auth @new_resource.username, @new_resource.password
        http.request request
      end

      Chef::Log.error response.body unless response.kind_of? Net::HTTPSuccess
      response
    end
  end
end
