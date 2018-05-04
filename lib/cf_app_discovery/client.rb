class CfAppDiscovery
  class Client
    attr_accessor :api_endpoint, :api_token

    def initialize(api_endpoint:, api_token:)
      self.api_endpoint = api_endpoint
      self.api_token = api_token
    end

    def apps
      paginator = Paginator.new do |next_url|
        get(next_url || "/v2/apps")
      end

      resources = paginator.flat_map do |page|
        page.fetch(:resources)
      end

      resources.each do |resource|
        resource[:route] = get_first_route(resource)
      end
      resources
    end

    def app(app_guid)
      resource = get("/v2/apps/#{app_guid}")
      resource[:route] = get_first_route(resource)
      resource
    end

    def service_binding(service_binding_id)
      get("/v2/service_bindings/#{service_binding_id}")
    end

    def routes(service_binding_id)
      get("/v2/apps/#{service_binding_id}/routes")
    end

  private

    def get_first_route(resource)
      routes_data = routes(resource.dig(:metadata, :guid)).fetch(:resources)
      if routes_data.first.nil?
        resource.dig :entity, :name
      else
        routes_data.first.dig :entity, :host
      end
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
  end
end
