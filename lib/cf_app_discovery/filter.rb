class CfAppDiscovery
  class Filter
    def filter_stopped(targets)
      targets.select(&:started?)
    end

    def filter_prometheus_available(targets)
      targets.select(&:prometheus_path)
    end
  end
end
