class CfAppDiscovery
  class TargetConfiguration
    attr_accessor :targets_path, :paas_domain

    def initialize(targets_path:, paas_domain:)
      self.targets_path = targets_path
      self.paas_domain = paas_domain
    end

    def write_targets(targets)
      targets.each { |t| write_if_changed(t) }
    end

    def configured_apps
      running_targets + stopped_targets
    end

  private

    def running_targets
      app_guids_from_path(targets_path)
    end

    def stopped_targets
      app_guids_from_path("#{targets_path}/stopped/")
    end

    def app_guids_from_path(path)
      app_guid_filename = /.*\/(.*)\.json/
      app_guids = Dir["#{path}/*.json"].map do |filename|
        app_guid = app_guid_filename.match(filename)
        app_guid[1] unless app_guid.nil?
      end
      app_guids.compact
    end

    def write_if_changed(target)
      json = json_content(target)
      path = guid_path(target)

      write(json, path) unless identical?(json, path)
    end

    def json_content(target)
      data = target.instances.times.map do |index|
        {
          targets: ["#{target.name}.#{paas_domain}"],
          labels: {
            __metrics_path__: target.prometheus_path,
            __param_cf_app_guid: target.guid,
            __param_cf_app_instance_index: index.to_s,
            cf_app_instance: index.to_s,
          }
        }
      end

      JSON.pretty_generate(data)
    end

    def guid_path(target)
      "#{targets_path}/#{target.guid}.json"
    end

    def write(content, path)
      File.open(path, "w") { |f| f.write(content) }
    end

    def identical?(content, path)
      File.exist?(path) && md5(File.read(path)) == md5(content)
    end

    def md5(content)
      Digest::MD5.hexdigest(content)
    end
  end
end
