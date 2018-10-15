require 'json'
require "spec_helper"

RSpec.describe CfAppDiscovery::Client do
  include StubHelper

  before do
    stub_endpoint(StubbableEndpoint::Get)
  end

  subject(:client) do
    described_class.new(
      api_endpoint: "http://api.example.com",
      api_token: "dummy-oauth-token",
      paas_domain: "example.com"
    )
  end

  it "performs a successful get request" do
    expect(client.get("/v2/apps/test")).to eq(metadata: {}, entity: {})
  end
end
