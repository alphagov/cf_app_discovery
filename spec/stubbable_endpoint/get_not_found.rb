module StubbableEndpoint
  module GetNotFound
    module_function

    def http_method
      :get
    end

    def url
      "http://api.example.com/v2/apps/not-found"
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
          description: "The app could not be found: not-found",
          error_code: "CF-AppNotFound",
          code: 100004,
      }
    end
  end
end
