class CfAppDiscovery
  class FilestoreManagerFactory
    def self.filestore_manager_builder(environment, targets_path)
      if environment.casecmp?('local')
        LocalManager.new(targets_path: targets_path, folders: %w(active inactive))
      else
        S3Manager.new(bucket_name: 'gds-prometheus-targets')
      end
    end
  end
end
