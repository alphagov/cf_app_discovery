class CfAppDiscovery
  def self.run(api_endpoint:, api_token:, targets_path:, paas_domain:)
    client = Client.new(
      api_endpoint: api_endpoint,
      api_token: api_token,
    )

    data = client.apps
    parser = Parser.new(data)
    targets = parser.targets

    template = Template.new(
      targets_path: targets_path,
      targets: targets,
      paas_domain: paas_domain,
    )

    template.write_all
  end
end
