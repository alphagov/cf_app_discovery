module StubbableEndpoint
    module Routes
    module_function
  
      def http_method
        :get
      end
  
      def url
        "https://api.example.com:80/v2/apps/app-1-guid/routes"
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
            "resources": [
                {
                    "metadata": {
                        "guid": "5e199364-fe75-46ac-bda9-03facdb66e9e",
                    },
                    "entity": {
                        "host": "test-different-route",
                    }
                },
                {
                    "metadata": {
                        "guid": "988814e0-783b-467e-be7b-9ece552b1eaa",
                    },
                    "entity": {
                        "host": "test-another-route",
                    }
                }
            ]
        }
      end
    end
  end
  