class CfAppDiscovery
  class Client
    attr_accessor :api_endpoint, :api_token

    def initialize(api_endpoint:, api_token:)
      self.api_endpoint = api_endpoint
      self.api_token = api_token
    end

    def apps
      get("/v2/apps")
    end

    private

    def get(path)
      uri = URI.parse("#{api_endpoint}#{path}")

      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "bearer #{api_token}"

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
