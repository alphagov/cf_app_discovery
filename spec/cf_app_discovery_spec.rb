require "spec_helper"

RSpec.describe CfAppDiscovery do
  include StubHelper

  before do
    stub_endpoint(StubbableEndpoint::Auth)
    stub_endpoint(StubbableEndpoint::Apps)
    stub_endpoint(StubbableEndpoint::AppsPage2)
    FileUtils.touch("#{targets_path}/app-1-guid.json")
    FileUtils.touch("#{stopped_targets_path}/app-2-guid.json")
    FileUtils.touch("#{targets_path}/app-3-guid.json")
  end

  let(:targets_path) { Dir.mktmpdir }
  let(:stopped_targets_path) do
    FileUtils.mkdir_p("#{targets_path}/stopped")
    "#{targets_path}/stopped"
  end

  it "reads app instances from the API and writes to the targets directory" do
    CfAppDiscovery.run(
      api_endpoint: "http://api.example.com",
      uaa_endpoint: "http://uaa.example.com",
      uaa_username: "uaa-username",
      uaa_password: "uaa-password",
      paas_domain:  "example.com",
      targets_path: targets_path,
    )
    names = filenames("#{targets_path}/*.json")
    expect(names).to eq(%w(app-2-guid.json app-3-guid.json))

    names = filenames("#{targets_path}/stopped/*.json")
    expect(names).to eq(%w(app-1-guid.json app-2-guid.json))
  end

  def filenames(path)
    listing = Dir[path]
    listing.map { |s| File.basename(s) }
  end
end
