class CfAppDiscovery
  class ServiceBroker < Sinatra::Application

    configure do
      set :api_endpoint, ENV.fetch("API_ENDPOINT")
      set :uaa_endpoint, ENV.fetch("UAA_ENDPOINT")
      set :uaa_username, ENV.fetch("UAA_USERNAME")
      set :uaa_password, ENV.fetch("UAA_PASSWORD")
      set :paas_domain,  ENV.fetch("PAAS_DOMAIN")
      set :targets_path, ENV.fetch("TARGETS_PATH")
    end

    get "/v2/catalog" do
      render(
        services: [
          {
            id: "fd609087-70e0-4c8c-8916-b6885ac156a3",
            name: "prometheus",
            description: "Test Prometheus service broker",
            bindable: true,
            plans: [
              {
                id: "b5998c91-d379-4df7-b329-11450f8459f1",
                name: "public",
                description: "something",
                free: true,
              },
            ],
          }
        ]
      )
    end

    put "/v2/service_instances/:id" do |id|
      content_type :json
      puts request.body.read
      # {"service_id":"fd609087-70e0-4c8c-8916-b6885ac156a3","plan_id":"b5998c91-d379-4df7-b329-11450f8459f1","organization_guid":"b92cf390-3dbb-4a6e-a24d-04a811c4624b","space_guid":"f523b565-a298-4efb-994b-b637dd97ace2","context":{"platform":"cloudfoundry","organization_guid":"b92cf390-3dbb-4a6e-a24d-04a811c4624b","space_guid":"f523b565-a298-4efb-994b-b637dd97ace2"}}
      render({})
    end

    put "/v2/service_instances/:instance_id/service_bindings/:id" do |instance_id, binding_id|
      content_type :json
      cf_request = request.body.read
      puts cf_request
      body_json = JSON.parse(cf_request, symbolize_names: true)
      app_guid = body_json.fetch(:bind_resource).fetch(:app_guid)
      app_data = client.app(app_guid)
      puts app_data
      parser = Parser.new([app_data])
      template = Template.new(
        targets_path: settings.targets_path,
        targets: parser.targets,
        paas_domain: settings.paas_domain
      )
      template.write_targets
      render({})
    end

    delete "/v2/service_instances/:instance_id/service_bindings/:id" do |instance_id, binding_id|
      puts request.body.read
      content_type :json
      render({})
    end

    delete "/v2/service_instances/:instance_id" do |instance_id|
      content_type :json
      render({})
    end

    private

    def render(payload)
      content_type :json
      payload.to_json
    end

    def client
      @client ||= Client.new(
        api_endpoint: settings.api_endpoint,
        api_token: api_token
      )
    end

    def api_token
      auth = Auth.new(
        uaa_endpoint: settings.uaa_endpoint,
        uaa_username: settings.uaa_username,
        uaa_password: settings.uaa_password,
      )
      auth.access_token
    end
  end
end
