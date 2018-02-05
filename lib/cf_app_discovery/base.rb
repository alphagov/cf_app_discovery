class CfAppDiscovery
  def self.run(params)
    new(params).run
  end

  def initialize(params)
    @api_endpoint = params.fetch(:api_endpoint)
    @uaa_endpoint = params.fetch(:uaa_endpoint)
    @uaa_username = params.fetch(:uaa_username)
    @uaa_password = params.fetch(:uaa_password)
    @paas_domain  = params.fetch(:paas_domain)
    @targets_path = params.fetch(:targets_path)
  end

  def run
    write_templates
  end

private

  def write_templates
    Template.new(
      targets_path: @targets_path,
      targets: targets,
      paas_domain: @paas_domain,
    ).write_all
  end

  def targets
    Parser.new(apps).targets
  end

  def apps
    Client.new(
      api_endpoint: @api_endpoint,
      api_token: access_token,
    ).apps
  end

  def access_token
    Auth.new(
      uaa_endpoint: @uaa_endpoint,
      uaa_username: @uaa_username,
      uaa_password: @uaa_password,
    ).access_token
  end
end
