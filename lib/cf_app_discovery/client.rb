class CfAppDiscovery
  class Client
    attr_accessor :api_endpoint, :api_token, :paas_domain

    def initialize(api_endpoint:, api_token:, paas_domain:)
      self.api_endpoint = api_endpoint
      self.api_token = api_token
      self.paas_domain = paas_domain
    end

    def get(path)
      uri = URI.parse("#{api_endpoint}#{path}")
      request = Net::HTTP::Get.new(uri)

      request["Authorization"] = "bearer #{api_token}"
      request["User-Agent"] = "cf_app_discovery - GDS - RE"

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      JSON.parse(response.body, symbolize_names: true)
    end

    def service_binding(service_binding_id)
      get("/v2/service_bindings/#{service_binding_id}")
    end

    def routes(service_binding_id)
      get("/v2/apps/#{service_binding_id}/routes")
    end

    def app_info(app_guid)
      get("/v2/apps/#{app_guid}")
    end

    def get_complete_list
      Paginator.new do |next_url|
        get(next_url || "/v2/apps")
      end
    end
  end
end
