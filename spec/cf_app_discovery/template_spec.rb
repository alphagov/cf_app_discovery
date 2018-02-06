require "spec_helper"

RSpec.describe CfAppDiscovery::Template do
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
      ),
      CfAppDiscovery::Parser::Target.new(
        guid: "app-2-guid",
        name: "app-2",
        instances: 1,
        state: "STARTED",
        env: {
          PROMETHEUS_METRICS_PATH: "/prometheus"
        },
      ),
    ]
  end

  subject do
    described_class.new(
      targets: targets,
      targets_path: targets_path,
      paas_domain: "example.com",
    )
  end

  let(:targets_path) { Dir.mktmpdir }

  it "writes files named after the target guids" do
    subject.write_targets

    listing = Dir["#{targets_path}/*.json"]
    names = listing.map { |s| File.basename(s) }

    expect(names).to eq(%w(app-1-guid.json app-2-guid.json))
  end

  it "writes an entry per instance for each target" do
    subject.write_targets

    listing = Dir["#{targets_path}/*.json"]
    contents = listing.map { |path| File.read(path) }

    first = JSON.parse(contents.first, symbolize_names: true)
    last = JSON.parse(contents.last, symbolize_names: true)
    expect(first).to eq [
      {
        targets: ["app-1.example.com/metrics"],
        labels: {
          __param_cf_app_guid: "app-1-guid",
          __param_cf_app_instance_index: 0,
          cf_app_instance: 0,
        },
      },
      {
        targets: ["app-1.example.com/metrics"],
        labels: {
          __param_cf_app_guid: "app-1-guid",
          __param_cf_app_instance_index: 1,
          cf_app_instance: 1,
        },
      },
    ]

    expect(last).to eq [
      {
        targets: ["app-2.example.com/prometheus"],
        labels: {
          __param_cf_app_guid: "app-2-guid",
          __param_cf_app_instance_index: 0,
          cf_app_instance: 0,
        },
      },
    ]
  end

  context "when the target files already exist" do
    before do
      subject.write_targets
      @first, @second = Dir["#{targets_path}/*.json"]

      File.open(@first, "w") { |f| f.write("this content is out of date") }

      FileUtils.touch(@first, mtime: 0)
      FileUtils.touch(@second, mtime: 0)
    end

    it "only writes files that have changed" do
      subject.write_targets

      expect(File.mtime(@first).to_i).not_to eq(0), "File should have been written"
      expect(File.mtime(@second).to_i).to eq(0), "File should not have been written"
    end
  end
end
