class CfAppDiscovery
  class TargetUpdater
    attr_accessor :app_info_configurer, :filestore_manager
    def initialize(filestore_manager:, app_info_configurer:)
      self.app_info_configurer = app_info_configurer
      self.filestore_manager = filestore_manager
    end

    def run
      target_configuration = TargetConfiguration.new(
        filestore_manager: filestore_manager,
      )

      parser = Parser.new(app_info_configurer.apps)
      targets = parser.targets

      filter = Filter.new

      configured_targets = filter.filter_prometheus_available(
        targets,
        target_configuration.configured_apps,
      )
      running_targets = filter.filter_stopped(configured_targets)
      stopped_targets = configured_targets - running_targets

      target_configuration.write_active_targets(running_targets)

      cleaner = Cleaner.new(
        filestore_manager: filestore_manager,
      )
      # Moving the stopped targets first so they are not removed by Cleaner
      cleaner.move_stopped_targets(stopped_targets)
    end
  end
end
