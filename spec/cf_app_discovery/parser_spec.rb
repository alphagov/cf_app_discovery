require "spec_helper"

RSpec.describe CfAppDiscovery::Parser do
  subject(:parser) do
    described_class.new(api_response)
  end

  let(:api_response) do
    [
      {
        metadata: { guid: "app-1-guid" },
        entity: {
          name: "app-1",
          instances: 2,
          state: "STARTED",
          detected_start_command: "./bin/paas-metric-exporter",
        },
        hostname: "route-1",
        domain: "example.com",
        space: "test-space-name",
        org: "org-name",
      },
      {
        metadata: { guid: "app-2-guid" },
        entity: {
          name: "app-2",
          instances: 3,
          state: "STOPPED",
          detected_start_command: "$HOME/boot.sh"
        },
        hostname: "route-2",
        domain: "example.com",
        space: "test-space-name",
        org: "org-name",
      },
      {
        metadata: { guid: "app-3-guid" },
        entity: {
          name: "app-3",
          instances: 2,
          state: "STARTED",
          detected_start_command: ""
        },
        hostname: "route-3",
        domain: "example.com",
        space: "test-space-name",
        org: "org-name",
      },
    ]
  end

  it "parses a target per resource" do
    expect(parser.targets.size).to eq(3)
    first, second, third = parser.targets

    expect(first.guid).to eq("app-1-guid")
    expect(first.name).to eq("app-1")
    expect(first.instances).to eq(2)
    expect(first.state).to eq("STARTED")
    expect(first.hostname).to eq("route-1")
    expect(first.detected_start_command).to eq("./bin/paas-metric-exporter")

    expect(second.guid).to eq("app-2-guid")
    expect(second.name).to eq("app-2")
    expect(second.instances).to eq(3)
    expect(second.state).to eq("STOPPED")
    expect(second.hostname).to eq("route-2")
    expect(second.detected_start_command).to eq("$HOME/boot.sh")

    expect(third.guid).to eq("app-3-guid")
    expect(third.name).to eq("app-3")
    expect(third.instances).to eq(2)
    expect(third.state).to eq("STARTED")
    expect(third.hostname).to eq("route-3")
    expect(third.detected_start_command).to eq("")
  end
end
