module StubbableEndpoint
  module AppsPage2
  module_function

    def http_method
      :get
    end

    def url
      "https://api.example.com:80/v2/apps?page=2"
    end

    def request_headers
      { "Authorization" => "bearer dummy-oauth-token" }
    end

    def request_body
      ""
    end

    def response_headers
      {}
    end

    def response_body
      {
        next_url: nil,
        prev_url: nil,
        resources: [
          {
            metadata: { guid: "app-3-guid" },
            entity: {
              name: "app-3",
              instances: 1,
              state: "STARTED",
              environment_json: {
                PROMETHEUS_METRICS_PATH: "/prometheus"
              },
            },
          },
        ]
      }
    end
  end
end
