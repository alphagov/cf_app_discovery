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
          route: resource.fetch(:route),
          space: resource.fetch(:space),
          org: resource.fetch(:org),
          detected_start_command: entity.fetch(:detected_start_command)
        )
      end
    end

    class Target
      attr_accessor :guid, :name, :instances, :state, :env, :route, :space, :org, :detected_start_command

      def initialize(guid:, name:, instances:, state:, env:, route:, space:, org:, detected_start_command:)
        self.guid = guid
        self.name = name
        self.instances = instances
        self.state = state
        self.env = env
        self.route = route
        self.space = space
        self.org = org
        self.detected_start_command = detected_start_command
      end

      def paas_metric_exporter?
        detected_start_command == "./bin/paas-metric-exporter"
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
