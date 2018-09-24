class CfAppDiscovery
  class Target
    attr_accessor :guid, :name, :instances, :state, :route, :space, :org, :detected_start_command

    def initialize(guid:, name:, instances:, state:, route:, space:, org:, detected_start_command:)
      self.guid = guid
      self.name = name
      self.instances = instances
      self.state = state
      self.route = route
      self.space = space
      self.org = org
      self.detected_start_command = detected_start_command
    end

    def paas_metric_exporter?
      detected_start_command == "./bin/paas-metric-exporter"
    end

    def started?
      state == "STARTED"
    end
  end
end