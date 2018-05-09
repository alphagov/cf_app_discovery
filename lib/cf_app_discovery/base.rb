class CfAppDiscovery
  def self.run(api_endpoint:, uaa_endpoint:, uaa_username:, uaa_password:, paas_domain:, targets_path:, environment:)
    filestore_manager = FilestoreManagerFactory.filestore_manager_builder(environment, targets_path)

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
    target_configuration.update_targets(targets)

    running_targets = filter.filter_stopped(configured_targets)
    stopped_targets = configured_targets - running_targets

    STDERR.puts "stopped targets###"
    STDERR.puts stopped_targets

    target_configuration.write_active_targets(running_targets)

    cleaner = Cleaner.new(
      filestore_manager: filestore_manager,
    )
    # Moving the stopped targets first so they are not removed by Cleaner
    cleaner.move_stopped_targets(stopped_targets)
  end
end
