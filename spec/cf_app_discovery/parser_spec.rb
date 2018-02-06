require "spec_helper"

RSpec.describe CfAppDiscovery::Parser do
  let(:api_response) do
    [
      {
        metadata: { guid: "app-1-guid" },
        entity: {
          name: "app-1",
          instances: 2,
        },
      },
      {
        metadata: { guid: "app-2-guid" },
        entity: {
          name: "app-2",
          instances: 3,
        },
      },
    ]
  end

  subject { described_class.new(api_response) }

  it "parses a target per resource" do
    expect(subject.targets.size).to eq(2)
    first, second = subject.targets

    expect(first.guid).to eq("app-1-guid")
    expect(first.name).to eq("app-1")
    expect(first.instances).to eq(2)

    expect(second.guid).to eq("app-2-guid")
    expect(second.name).to eq("app-2")
    expect(second.instances).to eq(3)
  end
end
