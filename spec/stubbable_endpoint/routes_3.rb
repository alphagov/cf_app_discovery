module StubbableEndpoint
  module Routes3
  module_function

      def http_method
        :get
      end

      def url
        "https://api.example.com:80/v2/apps/app-3-guid/routes"
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
          resources: [
            {
              entity: {
                  domain_url: "/v2/shared_domains/custom-domain-guid",
                  host: "",
              }
            },
          ]
        }
      end
  end
end
