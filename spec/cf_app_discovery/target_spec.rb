require "spec_helper"

RSpec.describe CfAppDiscovery::Target do
  it "Detects a paas metric exporter instance" do
    target = CfAppDiscovery::Target.new(guid:nil, name:nil, instances:nil, state:nil, route:nil, space:nil, org:nil,
                                          detected_start_command: "./bin/paas-metric-exporter")

    expect(target.paas_metric_exporter?).to be true
  end

  it "Detects a normal app" do
    target = CfAppDiscovery::Target.new(guid:nil, name:nil, instances:nil, state:nil, route:nil, space:nil, org:nil,
                                            detected_start_command: "")

    expect(target.paas_metric_exporter?).to be false
  end

  it "Detects a started target" do
    target = CfAppDiscovery::Target.new(guid:nil, name:nil, instances:nil, state:"STARTED", route:nil, space:nil, org:nil,
      detected_start_command: nil)

    expect(target.started?).to be true
  end

  it "Detects a stopped target" do
    target = CfAppDiscovery::Target.new(guid:nil, name:nil, instances:nil, state:"STOPPED", route:nil, space:nil, org:nil,
      detected_start_command: nil)

    expect(target.started?).to be false
  end

  it "Strips 'venerable' from app names" do
    target = CfAppDiscovery::Target.new(guid:nil, name:"app-name-venerable", instances:nil, state:nil, route:nil, space:nil, org:nil,
      detected_start_command: nil)

    expect(target.job).to eq("app-name")
  end

  it "Constructs instance index label" do
    target = CfAppDiscovery::Target.new(guid:"guid", name:nil, instances:nil, state:nil, route:nil, space:nil, org:nil,
      detected_start_command: nil)

    expect(target.instance(0)).to eq("guid:0")
  end
end