# frozen_string_literal: true

module StubbableEndpoint
  module Apps
    module_function

    def http_method
      :get
    end

    def url
      "http://api.example.com/v2/apps"
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
              state: "STOPPED",
              detected_start_command: nil,
              space_url: "/v2/spaces/example-space-guid",
            },
          },
          {
            metadata: { guid: "app-2-guid" },
            entity: {
              name: "app-2",
              instances: 2,
              state: "STARTED",
              detected_start_command: "./bin/paas-metric-exporter",
              space_url: "/v2/spaces/example-space-guid",
            },
          },
        ],
      }
    end
  end
end
