require "spec_helper"

RSpec.describe CfAppDiscovery::TargetConfiguration do
  include StubHelper

  let(:targets) do
    [
      CfAppDiscovery::Parser::Target.new(
        guid: "app-1-guid",
        name: "app-1",
        instances: 2,
        state: "STARTED",
        env: {
          PROMETHEUS_METRICS_PATH: "/metrics"
        },
        route: "test-1a"
      ),
      CfAppDiscovery::Parser::Target.new(
        guid: "app-2-guid",
        name: "app-2",
        instances: 1,
        state: "STARTED",
        env: {
          PROMETHEUS_METRICS_PATH: "/prometheus"
        },
        route: "test-2a"
      ),
    ]
  end

  subject do
    described_class.new(
      filestore_manager: LocalManager.new(targets_path: targets_path),
      paas_domain: "example.com",
    )
  end

  let(:targets_path) do
    path = Dir.mktmpdir

    FileUtils.mkdir_p("#{path}/active")
    FileUtils.mkdir_p("#{path}/inactive")

    path
  end

  it "writes files named after the target guids" do
    subject.write_active_targets(targets)

    listing = Dir["#{targets_path}/active/*.json"]
    names = listing.map { |s| File.basename(s) }

    expect(names).to eq(%w(app-1-guid.json app-2-guid.json))
  end

  it "writes an entry per instance for each target" do
    subject.write_active_targets(targets)

    listing = Dir["#{targets_path}/active/*.json"]
    contents = listing.map { |path| File.read(path) }

    first = JSON.parse(contents.first, symbolize_names: true)
    last = JSON.parse(contents.last, symbolize_names: true)
    expect(first).to eq [
      {
        targets: ["test-1a.example.com"],
        labels: {
          __metrics_path__: "/metrics",
          __param_cf_app_guid: "app-1-guid",
          __param_cf_app_instance_index: "0",
          cf_app_instance: "0",
          job: "app-1",
        },
      },
      {
        targets: ["test-1a.example.com"],
        labels: {
          __metrics_path__: "/metrics",
          __param_cf_app_guid: "app-1-guid",
          __param_cf_app_instance_index: "1",
          cf_app_instance: "1",
          job: "app-1",
        },
      },
    ]

    expect(last).to eq [
      {
        targets: ["test-2a.example.com"],
        labels: {
          __metrics_path__: "/prometheus",
          __param_cf_app_guid: "app-2-guid",
          __param_cf_app_instance_index: "0",
          cf_app_instance: "0",
          job: "app-2",
        },
      },
    ]
  end

  context "when the target files already exist" do
    before do
      subject.write_active_targets(targets)
      @first, @second = Dir["#{targets_path}/active/*.json"]

      File.open(@first, "w") { |f| f.write("this content is out of date") }

      FileUtils.touch(@first, mtime: 0)
      FileUtils.touch(@second, mtime: 0)
    end

    it "only writes files that have changed" do
      subject.write_active_targets(targets)

      expect(File.mtime(@first).to_i).not_to eq(0), "File should have been written"
      expect(File.mtime(@second).to_i).to eq(0), "File should not have been written"
    end

    it "lists the apps which have been configured" do
      subject.write_active_targets(targets)

      configured_apps = subject.configured_apps
      expect(configured_apps.to_set).to eq(Set.new(["app-1-guid", "app-2-guid"]))
    end
  end
end
