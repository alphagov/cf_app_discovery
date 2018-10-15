class CfAppDiscovery
  class Banana
    attr_reader :client, :paas_domain

    def initialize(api_endpoint:, api_token:, paas_domain:)
      @client = Client.new(
        api_endpoint: api_endpoint,
        api_token: api_token,
        paas_domain: paas_domain
      )
      @paas_domain = paas_domain
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

  private

    def set_first_route(resource)
      routes_data = @client.routes(resource.dig(:metadata, :guid)).fetch(:resources)

      if routes_data.first.nil?
        app_name = resource.dig(:entity, :name)
        resource[:route] = "#{app_name}.#{@paas_domain}"
      else
        domain_data = @client.get(routes_data.first.dig(:entity, :domain_url))
        host = routes_data.first.dig(:entity, :host)
        domain_name = domain_data.dig(:entity, :name)
        resource[:route] = if host.empty?
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
