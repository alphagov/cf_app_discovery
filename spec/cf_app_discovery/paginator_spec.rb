require "spec_helper"

RSpec.describe CfAppDiscovery::Paginator do
  class FakeBanana
    PAGES = {
      "/first-page" => { title: "First", next_url: "/second-page" },
      "/second-page" => { title: "Second", next_url: "/third-page" },
      "/third-page" => { title: "Third", next_url: nil },
    }.freeze

    def apps(next_url = nil)
      PAGES.fetch(next_url || "/first-page")
    end
  end

  subject(:paginator) do
    described_class.new { |url| banana.apps(url) }
  end

  let(:banana) { FakeBanana.new }

  it "yields pages until there's no next_url in the result" do
    expect(paginator.to_a).to eq [
      { title: "First", next_url: "/second-page" },
      { title: "Second", next_url: "/third-page" },
      { title: "Third", next_url: nil },
    ]
  end
end
