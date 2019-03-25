class CfAppDiscovery
  class CfClient
    attr_accessor :api_endpoint, :api_token, :paas_domain, :faraday_http_client

    def initialize(api_endpoint:, api_token:, paas_domain:)
      self.api_endpoint = api_endpoint
      self.api_token = api_token
      self.paas_domain = paas_domain

      self.faraday_http_client = Faraday.new do |builder|
        FaradayManualCache.configure do |config|
          config.memory_store = ActiveSupport::Cache::MemoryStore.new
        end
        builder.use :manual_cache,
                    conditions: ->(req) { req.method == :get || req.method == :head },
                    expires_in: ENV.fetch("CACHE_EXPIRY_TIME")
        builder.adapter Faraday.default_adapter
      end
    end

    def get(path)
      uri = URI.parse("#{api_endpoint}#{path}")
      response = faraday_http_client.get do |req|
        req.url uri
        req.headers["Authorization"] = "bearer #{api_token}"
        req.headers["User-Agent"] = "cf_app_discovery - GDS - RE"
      end
      if response.status != 200
        raise StandardError, "#{response.status}: #{response.body}"
      else
        JSON.parse(response.body, symbolize_names: true)
      end
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
