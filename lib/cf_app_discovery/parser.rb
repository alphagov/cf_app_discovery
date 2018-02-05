class CfAppDiscovery
  class Parser
    attr_accessor :data

    def initialize(data)
      self.data = data
    end

    def targets
      data.fetch(:resources).map do |resource|
        metadata = resource.fetch(:metadata)
        entity = resource.fetch(:entity)

        Target.new(
          guid: metadata.fetch(:guid),
          name: entity.fetch(:name),
          instances: entity.fetch(:instances),
        )
      end
    end

    def next_url
      data.fetch(:next_url)
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
