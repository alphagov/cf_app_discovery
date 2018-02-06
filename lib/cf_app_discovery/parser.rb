class CfAppDiscovery
  class Parser
    attr_accessor :api_response

    def initialize(api_response)
      self.api_response = api_response
    end

    def targets
      api_response.map do |resource|
        metadata = resource.fetch(:metadata)
        entity = resource.fetch(:entity)

        Target.new(
          guid: metadata.fetch(:guid),
          name: entity.fetch(:name),
          instances: entity.fetch(:instances),
          state: entity.fetch(:state),
          env: entity.fetch(:environment_json),
        )
      end
    end

    class Target
      attr_accessor :guid, :name, :instances, :state, :env

      def initialize(guid:, name:, instances:, state:, env:)
        self.guid = guid
        self.name = name
        self.instances = instances
        self.state = state
        self.env = env
      end

      def prometheus_path
        env[:PROMETHEUS_METRICS_PATH]
      end

      def started?
        state == "STARTED"
      end
    end
  end
end
