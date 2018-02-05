require "spec_helper"

RSpec.describe CfAppDiscovery::Auth do
  include StubHelper

  let(:endpoint) { StubbableEndpoint::Auth }
  before { stub_endpoint(endpoint) }

  subject do
    described_class.new(
      uaa_endpoint: "http://uaa.example.com",
      uaa_username: "uaa-username",
      uaa_password: "uaa-password",
    )
  end

  it "returns the oauth access token" do
    expect(subject.access_token).to eq("dummy-oauth-token")
  end
end
