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
      # This flag is used as a indicator that the target running is either the paas-metric-exporter or the
      # paas-prometheus-exporter. These two apps both require special treatement when generating their json.
      # This function can likely be renamed to `paas_prometheus_exporter?` after prometheus support is removed from
      # the pass-metric-exporter
      %w(./bin/paas-metric-exporter ./bin/paas-prometheus-exporter).include?(detected_start_command)
    end

    def started?
      state == "STARTED"
    end

    def generate_json(index)
      data = {
          targets: [route],
          labels: {
            __param_cf_app_guid: guid,
            __param_cf_app_instance_index: index.to_s,
            cf_app_instance: index.to_s,
            instance: instance(index),
            job: job,
            org: org,
          }
        }
      unless paas_metric_exporter?
        data[:labels][:space] = space
      end

      data
    end

    def instance(index)
      "#{guid}:#{index}"
    end

    def job
      # strip "-venerable" suffix from app names
      # so that autopilot deploys don't rename metrics
      name.sub(/-venerable$/, '')
    end
  end
end
