# frozen_string_literal: true

require "spec_helper"

RSpec.describe CfAppDiscovery::Filter do
  subject(:filter) { described_class.new }

  let(:targets) do
    [
      build(
        :target,
        guid: "app-1-guid",
        name: "app-1",
        state: "STARTED"
      ),
      build(:target,
            guid: "app-2-guid",
            name: "app-2",
            state: "STOPPED"),
      build(:target,
            guid: "app-3-guid",
            name: "app-3",
            state: "STARTED"),
    ]
  end

  it "filters target not running" do
    expect(filter.filter_stopped(targets)).to eq [targets.first, targets.last]
  end

  it "filters target based on given app guids" do
    expect(filter.filter_prometheus_available(targets, ["app-3-guid"])).to eq [targets.last]
  end
end
