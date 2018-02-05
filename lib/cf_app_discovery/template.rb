class CfAppDiscovery
  class Template
    attr_accessor :targets_path, :targets, :paas_domain

    def initialize(targets_path:, targets:, paas_domain:)
      self.targets_path = targets_path
      self.targets = targets
      self.paas_domain = paas_domain
    end

    def write_all
      targets.each { |t| write_if_changed(t) }
    end

  private

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
            __param_cf_app_guid: target.guid,
            __param_cf_app_instance_index: index,
            cf_app_instance: index,
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
