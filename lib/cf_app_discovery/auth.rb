class CfAppDiscovery
  class Auth
    READ_ONLY = "cloud_controller.read".freeze

    attr_accessor :uaa_endpoint, :uaa_username, :uaa_password

    def initialize(uaa_endpoint:, uaa_username:, uaa_password:)
      self.uaa_endpoint = uaa_endpoint
      self.uaa_username = uaa_username
      self.uaa_password = uaa_password
    end

    def access_token
      token_issuer.owner_password_grant(
        uaa_username,
        uaa_password,
        [READ_ONLY],
      ).info.fetch("access_token")
    end

    private

    def token_issuer
      CF::UAA::TokenIssuer.new(uaa_endpoint, "cf", "", {})
    end
  end
end
