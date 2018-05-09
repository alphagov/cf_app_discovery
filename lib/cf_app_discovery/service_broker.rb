class CfAppDiscovery
  class ServiceBroker < Sinatra::Application
    configure do
      set :api_endpoint, ENV.fetch("API_ENDPOINT")
      set :uaa_endpoint, ENV.fetch("UAA_ENDPOINT")
      set :uaa_username, ENV.fetch("UAA_USERNAME")
      set :uaa_password, ENV.fetch("UAA_PASSWORD")
      set :paas_domain, ENV.fetch("PAAS_DOMAIN")
      set :targets_path, ENV.fetch("TARGETS_PATH")
      set :environment, ENV.fetch("ENVIRONMENT")
    end

    get "/v2/catalog" do
      render(
        services: [
          {
            id: "37662bd8-3b59-4c81-a53e-b31c1090ad76",
            name: "gds-prometheus-test",
            description: "GDS internal Prometheus monitoring alpha https://reliability-engineering.cloudapps.digital/#metrics",
            bindable: true,
            plans: [
              {
                id: "ac1bfb35-0900-42d5-a237-b777df573681",
                name: "prometheus",
                description: "Monitor your apps using Prometheus",
                free: true,
              },
            ],
          }
        ]
      )
    end

    put "/v2/service_instances/:id" do
      content_type :json
      render({})
    end

    put "/v2/service_instances/:instance_id/service_bindings/:id" do
      content_type :json
      cf_request = request.body.read
      body_json = JSON.parse(cf_request, symbolize_names: true)
      app_guid = body_json.fetch(:bind_resource).fetch(:app_guid)
      app_data = client.app(app_guid)
      parser = Parser.new([app_data])
      template = TargetConfiguration.new(
        filestore_manager: filestore_manager,
        paas_domain: settings.paas_domain
      )
      template.write_active_targets(parser.targets)
      render({})
    end

    delete "/v2/service_instances/:instance_id/service_bindings/:id" do |_, binding_id|
      content_type :json
      service_binding = client.service_binding(binding_id)
      if service_binding.has_key?(:entity) == false
        STDERR.puts "service binding###"
        STDERR.puts service_binding
      else
        app_guid = service_binding.fetch(:entity).fetch(:app_guid)
        cleaner = Cleaner.new(filestore_manager: filestore_manager)
        cleaner.remove_old_target(app_guid)
      end
      render({})
    end

    delete "/v2/service_instances/:instance_id" do
      content_type :json
      render({})
    end

  private

    def filestore_manager
      @filestore_manager ||= FilestoreManagerFactory.filestore_manager_builder(
        settings.environment,
        settings.targets_path
      )
    end

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
