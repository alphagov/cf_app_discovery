module StubbableEndpoint
  module GetForbidden
    module_function

    def http_method
      :get
    end

    def url
      "http://api.example.com/v2/apps/forbidden-endpoint"
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
          description: "You are not authorized to perform the requested action",
          error_code: "CF-NotAuthorized",
          code: 10003,
      }
    end
  end
end
