require "spec_helper"

RSpec.describe CfAppDiscovery::Filter do
  subject(:filter) { described_class.new }

  let(:targets) do
    [
      CfAppDiscovery::Target.new(
        guid: "app-1-guid",
        name: "app-1",
        instances: 2,
        state: "STARTED",
        detected_start_command: "start.py",
        route: "route-1.example.com",
        space: "test-space-name",
        org: "org-name"
      ),
      CfAppDiscovery::Target.new(
        guid: "app-2-guid",
        name: "app-2",
        instances: 3,
        state: "STOPPED",
        detected_start_command: "start.py",
        route: "route-2.example.com",
        space: "test-space-name",
        org: "org-name"
      ),
      CfAppDiscovery::Target.new(
        guid: "app-3-guid",
        name: "app-3",
        instances: 2,
        state: "STARTED",
        detected_start_command: "start.py",
        route: "route-3.custom.com",
        space: "test-space-name",
        org: "org-name"
      ),
    ]
  end

  it "filters target not running" do
    expect(filter.filter_stopped(targets)).to eq [targets.first, targets.last]
  end

  it "filters target based on given app guids" do
    expect(filter.filter_prometheus_available(targets, ["app-3-guid"])).to eq [targets.last]
  end
end
