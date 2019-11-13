# frozen_string_literal: true

module StubbableEndpoint
  module Auth
    module_function

    def http_method
      :post
    end

    def url
      "http://uaa.example.com/oauth/token"
    end

    def request_headers
      { "Authorization" => "Basic Y2Y6" }
    end

    def request_body
      URI.encode_www_form(
        grant_type: "password",
        username: "uaa-username",
        password: "uaa-password",
        scope: "cloud_controller.read"
      )
    end

    def response_headers
      { "Content-Type" => "application/json" }
    end

    def response_body
      {
        access_token: "dummy-oauth-token",
        token_type: "bearer",
      }
    end
  end
end
