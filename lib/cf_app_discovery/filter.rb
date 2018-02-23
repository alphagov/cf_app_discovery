class CfAppDiscovery
  class Filter
    def filter_stopped(targets)
      targets.select(&:started?)
    end

    def filter_prometheus_available(targets, app_guids)
      targets.select do |target|
        app_guids.include?(target.guid)
      end
    end
  end
end
