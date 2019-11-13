class CfAppDiscovery
  class TargetConfiguration
    attr_accessor :filestore_manager

    def initialize(filestore_manager:)
      self.filestore_manager = filestore_manager
    end

    def write_active_targets(targets)
      write_targets(targets, "active")
    end

    def write_inactive_targets(targets)
      write_targets(targets, "inactive")
    end

    def configured_apps
      running_targets + stopped_targets
    end

  private

    def write_targets(targets, folder)
      targets.each { |t| write_if_changed(t, folder) }
    end

    def running_targets
      app_guids_from_path("active")
    end

    def stopped_targets
      app_guids_from_path("inactive")
    end

    def app_guids_from_path(path)
      app_guid_filename = /.*\/(.*)\.json/
      app_guids = filestore_manager.filenames(path).map do |filename|
        app_guid = app_guid_filename.match(filename)
        app_guid[1] unless app_guid.nil?
      end
      app_guids.compact
    end

    def write_if_changed(target, folder)
      json = json_content(target)
      path = guid_path(folder, target)
      write(json, path) unless identical?(json, path)
    end

    def json_content(target)
      data = target.instances.times.map do |index|
        target.generate_json(index)
      end

      JSON.pretty_generate(data)
    end

    def guid_path(folder, target)
      "#{folder}/#{target.guid}.json"
    end

    def write(content, path)
      filestore_manager.write(content, path)
    end

    def identical?(content, path)
      filestore_manager.exist?(path) &&
        md5(filestore_manager.read(path)) == md5(content)
    end

    def md5(content)
      Digest::MD5.hexdigest(content)
    end
  end
end
