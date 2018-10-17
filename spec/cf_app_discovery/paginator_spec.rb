require "spec_helper"

RSpec.describe CfAppDiscovery::Paginator do
  class FakeAppInfoConfigurer
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
    described_class.new { |url| app_info_configurer.apps(url) }
  end

  let(:app_info_configurer) { FakeAppInfoConfigurer.new }

  it "yields pages until there's no next_url in the result" do
    expect(paginator.to_a).to eq [
      { title: "First", next_url: "/second-page" },
      { title: "Second", next_url: "/third-page" },
      { title: "Third", next_url: nil },
    ]
  end
end
