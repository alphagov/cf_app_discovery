require "spec_helper"

RSpec.describe CfAppDiscovery::RouteRemapper do
  subject { described_class.new }

  let(:guid) { "00000000-0000-0000-0000-000000000001" }

  let(:current_target) do
    CfAppDiscovery::Parser::Target.new(guid: guid, name: "foo", instances: 1, state: "", env: {}, route: "old-route")
  end


  it "falls back to ne name as route when the route is deleted" do
    expect(current_target.route).to eq("old-route")
    current_target = CfAppDiscovery::Parser::Target.new(guid: guid, name: "foo", instances: 1, state: "", env: {}, route: nil)
    expect(current_target.route).to eq("foo")
  end

end
