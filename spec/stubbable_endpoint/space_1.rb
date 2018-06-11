module StubbableEndpoint
  module Space1
  module_function

      def http_method
        :get
      end

      def url
        "https://api.example.com:80/v2/spaces/example-space-guid"
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
            entity: {
              name: "test-space-name",
              organization_url: "/v2/organizations/example-org-guid",
            }
        }
      end
  end
end
