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
          route: resource.fetch(:route),
          space: resource.fetch(:space),
          org: resource.fetch(:org),
          detected_start_command: entity.fetch(:detected_start_command)
        )
      end
    end
  end
end
