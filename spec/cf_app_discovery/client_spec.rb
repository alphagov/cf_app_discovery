require "spec_helper"

RSpec.describe CfAppDiscovery::Client do
  include StubHelper

  let(:endpoint) { StubbableEndpoint::Apps }
  before { stub_endpoint(endpoint) }

  subject do
    described_class.new(
      api_endpoint: "http://api.example.com",
      api_token: "dummy-oauth-token",
    )
  end

  it "returns the apps data from the api" do
    expect(subject.apps).to eq(endpoint.response_body)
  end
end
