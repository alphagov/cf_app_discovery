module StubbableEndpoint
  module Routes1
  module_function

    route = {
        http_method: :get, 
        url: "https://api.example.com:80/v2/apps/app-1-guid/routes",
        request_headers: {
          "Authorization" => "bearer dummy-oauth-token",
          "User-Agent" => "cf_app_discovery - GDS - RE",
        },
        request_body: {},
        response_headers: {},
        response_body: 
          {
            resources: [
              {
                entity: {
                  domain_url: "/v2/shared_domains/domain-guid",
                  host: "route-1a",
                }
              },
              {
                entity: {
                  domain_url: "/v2/shared_domains/domain-guid",
                  host: "route-1b",
                }
            },
          ]
      }
        }
  end
end
