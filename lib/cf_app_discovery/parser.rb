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
        )
      end
    end

    class Target
      attr_accessor :guid, :name, :instances

      def initialize(guid:, name:, instances:)
        self.guid = guid
        self.name = name
        self.instances = instances
      end
    end
  end
end
