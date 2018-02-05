class CfAppDiscovery
  class Paginator
    include Enumerable

    attr_accessor :block

    def initialize(&block)
      self.block = block
    end

    def each
      next_url = nil

      loop do
        result = block.call(next_url)
        yield result

        next_url = result.fetch(:next_url)
        break unless next_url
      end
    end
  end
end
