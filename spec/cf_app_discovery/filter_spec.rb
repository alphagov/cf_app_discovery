require "spec_helper"

RSpec.describe CfAppDiscovery::Filter do
  let(:targets) do
    [
      CfAppDiscovery::Parser::Target.new(
        guid: "app-1-guid",
        name: "app-1",
        instances: 2,
        state: "STARTED",
        env: {},
      ),
      CfAppDiscovery::Parser::Target.new(
        guid: "app-2-guid",
        name: "app-2",
        instances: 3,
        state: "STOPPED",
        env: {
          PROMETHEUS_METRICS_PATH: "/prometheus"
        }
      ),
      CfAppDiscovery::Parser::Target.new(
        guid: "app-3-guid",
        name: "app-3",
        instances: 2,
        state: "STARTED",
        env: {
          PROMETHEUS_METRICS_PATH: "/prometheus"
        }
      ),
    ]
  end

  it "should filter target not running" do
    expect(subject.filter_stopped(targets)).to eq [targets.first, targets.last]
  end

  it "should filter target not configured for prometheus" do
    expect(subject.filter_prometheus_available(targets, ["app-3-guid"])).to eq [targets.last]
  end
end
