class CfAppDiscovery
  def self.run(api_endpoint:, uaa_endpoint:, uaa_username:, uaa_password:, paas_domain:, targets_path:)
    filestore_manager = S3Manager.new('engineering.reliability.gds.prometheus.targets')

    target_configuration = TargetConfiguration.new(
      filestore_manager: filestore_manager,
      paas_domain: paas_domain,
    )

    auth = Auth.new(
      uaa_endpoint: uaa_endpoint,
      uaa_username: uaa_username,
      uaa_password: uaa_password,
    )

    client = Client.new(
      api_endpoint: api_endpoint,
      api_token: auth.access_token,
    )

    parser = Parser.new(client.apps)
    targets = parser.targets

    filter = Filter.new
    configured_targets = filter.filter_prometheus_available(
      targets,
      target_configuration.configured_apps
    )
    running_targets = filter.filter_stopped(configured_targets)
    stopped_targets = configured_targets - running_targets

    target_configuration.write_targets(running_targets)

    cleaner = Cleaner.new(
      targets_path: targets_path,
    )
    # Moving the stopped targets first so they are not removed by Cleaner
    cleaner.move_stopped_targets(stopped_targets)
  end
end
