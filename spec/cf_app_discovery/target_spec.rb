require "spec_helper"

RSpec.describe CfAppDiscovery::Target do
  it "Detects a paas metric exporter instance" do
    target = build(:target, detected_start_command: "./bin/paas-metric-exporter")
    expect(target.paas_metric_exporter?).to be true
  end

  it "Detects a paas prometheus exporter instance" do
    target = build(:target, detected_start_command: "./bin/paas-prometheus-exporter")
    expect(target.paas_metric_exporter?).to be true
  end

  it "Detects a normal app" do
    target = build(:target, detected_start_command: "")
    expect(target.paas_metric_exporter?).to be false
  end

  it "Detects a started target" do
    target = build(:target, state: "STARTED")
    expect(target.started?).to be true
  end

  it "Detects a stopped target" do
    target = build(:target, state: "STOPPED")
    expect(target.started?).to be false
  end

  it "Strips 'venerable' from app names" do
    target = build(:target, name: "app-name-venerable")
    expect(target.job).to eq("app-name")
  end

  it "Constructs instance index label" do
    target = build(:target, guid: "guid")
    expect(target.instance(0)).to eq("guid:0")
  end

  it "Does not generate metrics path given empty path" do
    target = build(:target, guid: "guid", name: "", path: "")
    expect(target.generate_json(0)[:labels].has_key?(:__metrics_path__)).to be false
  end

  it "Generates metrics path given path without metrics" do
    target = build(:target, guid: "guid", name: "", path: "hello")
    expect(target.generate_json(0)[:labels][:__metrics_path__]).to eq("hello/metrics")
  end

  it "Returns given metrics path given path with metrics" do
    target = build(:target, guid: "guid", name: "", path: "hello/metrics")
    expect(target.generate_json(0)[:labels][:__metrics_path__]).to eq("hello/metrics")
  end
end
