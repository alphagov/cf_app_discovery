class CfAppDiscovery
  class ServiceBroker < Sinatra::Application
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
      render({})
    end

    put "/v2/service_instances/:instance_id/service_bindings/:id" do |instance_id, binding_id|
      content_type :json
    end

    delete "/v2/service_instances/:instance_id/service_bindings/:id" do |instance_id, binding_id|
      content_type :json
    end

    delete "/v2/service_instances/:instance_id" do |instance_id|
      content_type :json
    end

    private

    def render(payload)
      content_type :json
      payload.to_json
    end
  end
end
