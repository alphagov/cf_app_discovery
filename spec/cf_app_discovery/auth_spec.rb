require "spec_helper"

RSpec.describe CfAppDiscovery::Auth do
  include StubHelper

  subject(:auth) do
    described_class.new(
      uaa_endpoint: "http://uaa.example.com",
      uaa_username: "uaa-username",
      uaa_password: "uaa-password",
    )
  end

  let(:endpoint) { StubbableEndpoint::Auth }

  before { stub_endpoint(endpoint) }

  it "returns the oauth access token" do
    expect(auth.access_token).to eq("dummy-oauth-token")
  end
end
