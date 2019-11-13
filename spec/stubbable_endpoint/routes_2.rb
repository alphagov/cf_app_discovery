# frozen_string_literal: true

module StubbableEndpoint
  module Routes2
    module_function

    def http_method
      :get
    end

    def url
      'http://api.example.com/v2/apps/app-2-guid/routes'
    end

    def request_headers
      {
        'Authorization' => 'bearer dummy-oauth-token',
        'User-Agent' => 'cf_app_discovery - GDS - RE',
      }
    end

    def request_body
      ''
    end

    def response_headers
      {}
    end

    def response_body
      {
        resources: [
          {
            entity: {
              domain_url: '/v2/shared_domains/domain-guid',
              host: 'route-2a',
              path: '',
            },
          },
          {
            entity: {
              domain_url: '/v2/shared_domains/domain-guid',
              host: 'route-2b',
              path: '',
            },
          }
        ],
      }
    end
  end
end
