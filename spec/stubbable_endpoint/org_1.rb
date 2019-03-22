module StubbableEndpoint
  module Org1
  module_function

      def http_method
        :get
      end

      def url
        "http://api.example.com/v2/organizations/example-org-guid"
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
              name: "org-name",
            }
        }
      end
  end
end
