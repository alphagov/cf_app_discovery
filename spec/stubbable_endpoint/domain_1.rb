module StubbableEndpoint
  module Domain1
  module_function

    def http_method
      :get
    end

    def url
      "https://api.example.com:80/v2/shared_domains/domain-guid"
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
              name: "example.com",
          }
      }
    end
  end
end
