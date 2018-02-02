require "spec_helper"

RSpec.describe CfAppDiscovery do
  include StubHelper

  before do
    stub_apps_api_endpoint
  end

  let(:targets_path) { Dir.mktmpdir }

  it "reads app instances from the API and writes to the targets directory" do
    CfAppDiscovery.run(
      api_endpoint: "http://example.com",
      api_token: "dummy-oauth-token",
      targets_path: targets_path,
      paas_domain: "example.com",
    )

    listing = Dir["#{targets_path}/*.json"]
    names = listing.map { |s| File.basename(s) }

    expect(names).to eq(%w(app-1-guid.json app-2-guid.json))
  end

  it "does not write files if they haven't changed"

  it "sets the user agent to something"
end
