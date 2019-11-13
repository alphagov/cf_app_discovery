module StubbableEndpoint
  module Domain2
    module_function

    def http_method
      :get
    end

    def url
      "http://api.example.com/v2/shared_domains/custom-domain-guid"
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
              name: "custom-domain.gov.uk",
          },
      }
    end
  end
end
