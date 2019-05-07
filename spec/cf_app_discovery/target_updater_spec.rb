require "spec_helper"

RSpec.describe CfAppDiscovery::TargetUpdater do
  include StubHelper

  subject(:target_updater) do
    described_class.new(
      filestore_manager: LocalManager.new(targets_path: targets_path, folders: %w(active inactive)),
      app_info_configurer: CfAppDiscovery::AppInfoConfigurer.new(
        api_endpoint: "http://api.example.com",
        api_token: "dummy-oauth-token",
        paas_domain: "example.com"
      )
    )
  end

  before do
    stub_endpoint(StubbableEndpoint::SharedDomains)
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
    target_updater.run
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
