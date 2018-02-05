require "spec_helper"

RSpec.describe CfAppDiscovery::Paginator do
  class FakeClient
    PAGES = {
      "/first-page" => { title: "First", next_url: "/second-page" },
      "/second-page" => { title: "Second", next_url: "/third-page" },
      "/third-page" => { title: "Third", next_url: nil },
    }.freeze

    def apps(next_url = nil)
      PAGES.fetch(next_url || "/first-page")
    end
  end

  let(:client) { FakeClient.new }

  subject do
    described_class.new { |url| client.apps(url) }
  end

  it "yields pages until there's no next_url in the result" do
    expect(subject.to_a).to eq [
      { title: "First", next_url: "/second-page" },
      { title: "Second", next_url: "/third-page" },
      { title: "Third", next_url: nil },
    ]
  end
end
