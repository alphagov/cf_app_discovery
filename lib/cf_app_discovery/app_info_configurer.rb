require 'logger'

class CfAppDiscovery
  class AppInfoConfigurer
    attr_reader :paas_domain
    attr_accessor :client

    def initialize(api_endpoint:, api_token:, paas_domain:)
      @client = CfClient.new(
        api_endpoint: api_endpoint,
        api_token: api_token,
        paas_domain: paas_domain
      )
      @paas_domain = paas_domain
      @logger = Logger.new(STDOUT)
    end

    def apps
      app_list = @client.get_complete_list

      resources = app_list.flat_map do |page|
        page.fetch(:resources)
      end

      resources.each do |resource|
        set_space_and_org(resource)
        set_first_route(resource)
      end
      resources
    end

    def app(app_guid)
      resource = @client.app_info(app_guid)
      set_space_and_org(resource)
      set_first_route(resource)
    end

    def set_first_route(resource)
      routes_data = @client.routes(resource.dig(:metadata, :guid)).fetch(:resources)
      shared_domains_data = @client.get('/v2/shared_domains')
      internal_domains = shared_domains_data[:resources].select { |r| r[:entity][:internal] }.map { |e| e[:metadata][:url] }
      public_routes_data = routes_data.reject { |r| internal_domains.include?(r[:entity][:domain_url]) }
      if public_routes_data.empty?
        app_name = resource.dig(:entity, :name)
        @logger.warn("Couldn't find a public route for #{app_name}; guessing a route")
        resource[:hostname] = "#{app_name}.#{@paas_domain}"
        resource[:path] = ""
      else
        public_routes_metrics = public_routes_data.select { |r| r.dig(:entity, :path).end_with?('metrics') }
        chosen_public_route = if public_routes_metrics.empty?
                                public_routes_data.first
                              else
                                public_routes_metrics.first
                              end
        domain_data = @client.get(chosen_public_route.dig(:entity, :domain_url))
        host = chosen_public_route.dig(:entity, :host)
        resource[:path] = chosen_public_route.dig(:entity, :path)
        domain_name = domain_data.dig(:entity, :name)
        resource[:hostname] = if host.empty?
                                domain_name
                              else
                                "#{host}.#{domain_name}"
                              end
      end
      resource
    end

    def set_space_and_org(resource)
      space_data = @client.get(resource.dig(:entity, :space_url))
      org_data = @client.get(space_data.dig(:entity, :organization_url))

      resource[:space] = space_data.dig(:entity, :name)
      resource[:org] = org_data.dig(:entity, :name)
      resource
    end
  end
end
