module StubbableEndpoint
  module Apps
    module_function

    def method
      :get
    end

    def url
      "https://api.example.com:80/v2/apps"
    end

    def request_headers
      { "Authorization"=>"bearer dummy-oauth-token" }
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
            metadata: { guid: "app-1-guid" },
            entity: {
              name: "app-1",
              instances: 2,
            },
          },
          {
            metadata: { guid: "app-2-guid" },
            entity: {
              name: "app-2",
              instances: 3,
            },
          },
        ]
      }
    end
  end
end
