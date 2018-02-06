require "spec_helper"

RSpec.describe CfAppDiscovery::Client do
  include StubHelper

  let(:first_page) { StubbableEndpoint::Apps }
  let(:second_page) { StubbableEndpoint::AppsPage2 }

  before { stub_endpoint(first_page) }
  before { stub_endpoint(second_page) }

  subject do
    described_class.new(
      api_endpoint: "http://api.example.com",
      api_token: "dummy-oauth-token",
    )
  end

  it "returns the apps data from the api" do
    all_apps = first_page.response_body.fetch(:resources)
    all_apps += second_page.response_body.fetch(:resources)

    expect(Net::HTTP).to receive(:start).twice.and_call_original
    expect(subject.apps).to eq(all_apps)
  end
end
