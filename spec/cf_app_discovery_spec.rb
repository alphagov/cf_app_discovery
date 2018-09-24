require "spec_helper"

RSpec.describe CfAppDiscovery do
  include StubHelper

  before do
    stub_endpoint(StubbableEndpoint::Auth)
    stub_endpoint(StubbableEndpoint::Apps)
    stub_endpoint(StubbableEndpoint::AppsPage2)
    stub_endpoint(StubbableEndpoint::Domain1)
    stub_endpoint(StubbableEndpoint::Domain2)
    stub_endpoint(StubbableEndpoint::Org1)
    stub_endpoint(StubbableEndpoint::Routes1)
    stub_endpoint(StubbableEndpoint::Routes2)
    stub_endpoint(StubbableEndpoint::Routes3)
    stub_endpoint(StubbableEndpoint::Routes4)
    stub_endpoint(StubbableEndpoint::Space1)
    FileUtils.touch("#{active_targets_path}/app-1-guid.json")
    FileUtils.touch("#{inactive_targets_path}/app-2-guid.json")
    FileUtils.touch("#{active_targets_path}/app-3-guid.json")
  end

  let(:targets_path) do
    path = Dir.mktmpdir

    FileUtils.mkdir_p("#{path}/active")
    FileUtils.mkdir_p("#{path}/inactive")

    path
  end

  let(:active_targets_path) do
    "#{targets_path}/active"
  end

  let(:inactive_targets_path) do
    "#{targets_path}/inactive"
  end

  it "reads app instances from the API and writes to the targets directory" do
    described_class.run(
      api_endpoint: "http://api.example.com",
      uaa_endpoint: "http://uaa.example.com",
      uaa_username: "uaa-username",
      uaa_password: "uaa-password",
      paas_domain: "example.com",
      targets_path: targets_path,
      environment: 'local',
    )
    names = filenames("#{active_targets_path}/*.json")
    expect(names).to contain_exactly('app-2-guid.json', 'app-3-guid.json')

    names = filenames("#{inactive_targets_path}/*.json")
    expect(names).to contain_exactly('app-1-guid.json', 'app-2-guid.json')
  end

  def filenames(path)
    listing = Dir[path]
    listing.map { |s| File.basename(s) }
  end
end
