class CfAppDiscovery
  class Client
    attr_accessor :api_endpoint, :api_token, :paas_domain

    def initialize(api_endpoint:, api_token:, paas_domain:)
      self.api_endpoint = api_endpoint
      self.api_token = api_token
      self.paas_domain = paas_domain
    end

    def apps
      paginator = Paginator.new do |next_url|
        get(next_url || "/v2/apps")
      end

      resources = paginator.flat_map do |page|
        page.fetch(:resources)
      end

      resources.each do |resource|
        set_first_route(resource)
      end
      resources
    end

    def app(app_guid)
      resource = get("/v2/apps/#{app_guid}")
      set_first_route(resource)
    end

    def service_binding(service_binding_id)
      get("/v2/service_bindings/#{service_binding_id}")
    end

    def routes(service_binding_id)
      get("/v2/apps/#{service_binding_id}/routes")
    end

  private

    def set_first_route(resource)
      routes_data = routes(resource.dig(:metadata, :guid)).fetch(:resources)

      if routes_data.first.nil?
        app_name = resource.dig(:entity, :name)
        resource[:route] = "#{app_name}.#{paas_domain}"
      else
        domain_data = get(routes_data.first.dig(:entity, :domain_url))
        host = routes_data.first.dig(:entity, :host)
        domain_name = domain_data.dig(:entity, :name)
        resource[:route] = if host.empty?
                             domain_name
                           else
                             "#{host}.#{domain_name}"
                           end
      end
      resource
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
