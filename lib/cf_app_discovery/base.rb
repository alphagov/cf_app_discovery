class CfAppDiscovery
  def self.run(params)
    new(params).run
  end

  def initialize(params)
    @api_endpoint = params.fetch(:api_endpoint)
    @uaa_endpoint = params.fetch(:uaa_endpoint)
    @uaa_username = params.fetch(:uaa_username)
    @uaa_password = params.fetch(:uaa_password)
    @paas_domain = params.fetch(:paas_domain)
    @targets_path = params.fetch(:targets_path)
  end

  def run
    process_targets
  end

private

  def process_targets
    path = '/v2/apps?results-per-page=1'
    client = create_client

    loop do
      puts "Path: #{path}"

      apps = get_apps(client, path)
      parser = create_parser(apps)
      targets = get_targets(parser)

      write_templates(targets)

      path = get_next_url(parser)

      break if path.nil?
    end
  end

  def write_templates(targets)
    Template.new(
      targets_path: @targets_path,
      targets: targets,
      paas_domain: @paas_domain,
    ).write_all
  end

  def get_targets(parser)
    parser.targets
  end

  def get_next_url(parser)
    parser.next_url
  end

  def create_parser(apps)
    Parser.new(apps)
  end

  def get_apps(client, path)
    client.apps(path)
  end

  def create_client
    Client.new(
      api_endpoint: @api_endpoint,
      api_token: access_token,
    )
  end

  def access_token
    Auth.new(
      uaa_endpoint: @uaa_endpoint,
      uaa_username: @uaa_username,
      uaa_password: @uaa_password,
    ).access_token
  end
end
