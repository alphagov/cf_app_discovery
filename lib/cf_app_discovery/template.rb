class CfAppDiscovery
  class Template
    attr_accessor :targets_path, :targets, :paas_domain

    def initialize(targets_path:, targets:, paas_domain:)
      self.targets_path = targets_path
      self.targets = targets
      self.paas_domain = paas_domain
    end

    def write_all
      targets.each do |target|
        write(target, content(target))
      end
    end

  private

    def content(target)
      target.instances.times.map do |index|
        {
          targets: ["#{target.name}.#{paas_domain}"],
          labels: {
            __param_cf_app_guid: target.guid,
            __param_cf_app_instance_index: index,
            cf_app_instance: index,
          }
        }
      end
    end

    def write(target, content)
      json = JSON.pretty_generate(content)

      File.open("#{targets_path}/#{target.guid}.json", "w") do |file|
        file.write(json)
      end
    end
  end
end
