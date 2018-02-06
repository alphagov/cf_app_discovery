require "spec_helper"

RSpec.describe CfAppDiscovery do
  include StubHelper

  before do
    stub_endpoint(StubbableEndpoint::Auth)
    stub_endpoint(StubbableEndpoint::Apps)
    stub_endpoint(StubbableEndpoint::AppsPage2)
  end

  let(:targets_path) { Dir.mktmpdir }

  it "reads app instances from the API and writes to the targets directory" do
    CfAppDiscovery.run(
      api_endpoint: "http://api.example.com",
      uaa_endpoint: "http://uaa.example.com",
      uaa_username: "uaa-username",
      uaa_password: "uaa-password",
      paas_domain:  "example.com",
      targets_path: targets_path,
    )

    listing = Dir["#{targets_path}/*.json"]
    names = listing.map { |s| File.basename(s) }

    expect(names).to eq(%w(app-2-guid.json app-3-guid.json))
  end

  it "sets the user agent to something"
end
