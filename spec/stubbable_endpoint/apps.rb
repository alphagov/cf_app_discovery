module StubbableEndpoint
  module Apps
  module_function

    def http_method
      :get
    end

    def url
      "https://api.example.com:80/v2/apps"
    end

    def request_headers
      {
        "Authorization" => "bearer dummy-oauth-token",
        "User-Agent" => "cf_app_discovery - GDS - RE",
      }
    end

    def request_body
      ""
    end

    def response_headers
      {}
    end

    def response_body
      {
        next_url: "/v2/apps?page=2",
        prev_url: nil,
        resources: [
          {
            metadata: { guid: "app-1-guid" },
            entity: {
              name: "app-1",
              instances: 2,
              state: "STARTED",
              environment_json: {},
            },
          },
          {
            metadata: { guid: "app-2-guid" },
            entity: {
              name: "app-2",
              instances: 3,
              state: "STARTED",
              environment_json: {
                PROMETHEUS_METRICS_PATH: "/metrics"
              },
            },
          },
        ]
      }
    end
  end
end
