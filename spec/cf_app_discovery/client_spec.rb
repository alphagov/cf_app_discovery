require "spec_helper"

RSpec.describe CfAppDiscovery::Client do
  include StubHelper

  before do
    stub_apps_api_endpoint
  end

  subject do
    described_class.new(
      api_endpoint: "http://example.com",
      api_token: "dummy-oauth-token",
    )
  end

  describe "#apps" do
    it "returns the parsed response data" do
      data = subject.apps
      expect(data).to eq(response_data)
    end
  end
end
