module StubbableEndpoint
  module App
  module_function

    def http_method
      :get
    end

    def url
      "https://api.example.com:80/v2/apps/app-1-guid"
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
        metadata: { guid: "app-1-guid" },
        entity: {
          name: "app-1",
          instances: 2,
          state: "STARTED",
          environment_json: {},
          detected_start_command: nil,
          space_url: "/v2/spaces/example-space-guid",
        },
      }
    end
  end
end
