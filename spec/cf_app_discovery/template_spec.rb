require "spec_helper"

RSpec.describe CfAppDiscovery::Template do
  let(:targets) do
    [
      CfAppDiscovery::Parser::Target.new(
        guid: "app-1-guid",
        name: "app-1",
        instances: 2,
      ),
      CfAppDiscovery::Parser::Target.new(
        guid: "app-2-guid",
        name: "app-2",
        instances: 3,
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
    subject.write_all

    listing = Dir["#{targets_path}/*.json"]
    names = listing.map { |s| File.basename(s) }

    expect(names).to eq(%w(app-1-guid.json app-2-guid.json))
  end

  it "writes an entry per instance for each target" do
    subject.write_all

    listing = Dir["#{targets_path}/*.json"]
    contents = listing.map { |path| File.read(path) }

    first = JSON.parse(contents.first, symbolize_names: true)
    expect(first).to eq [
      {
        targets: ["app-1.example.com"],
        labels: {
          __param_cf_app_guid: "app-1-guid",
          __param_cf_app_instance_index: 0,
          cf_app_instance: 0,
        },
      },
      {
        targets: ["app-1.example.com"],
        labels: {
          __param_cf_app_guid: "app-1-guid",
          __param_cf_app_instance_index: 1,
          cf_app_instance: 1,
        },
      },
    ]
  end
end
