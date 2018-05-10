require "spec_helper"

RSpec.describe CfAppDiscovery::Client do
  include StubHelper

  let(:first_page) { StubbableEndpoint::Apps }
  let(:second_page) { StubbableEndpoint::AppsPage2 }

  before { stub_endpoint(first_page) }
  before { stub_endpoint(second_page) }
  before { stub_endpoint(StubbableEndpoint::Domain1) }
  before { stub_endpoint(StubbableEndpoint::Domain2) }
  before { stub_endpoint(StubbableEndpoint::Routes1) }
  before { stub_endpoint(StubbableEndpoint::Routes2) }
  before { stub_endpoint(StubbableEndpoint::Routes3) }
  before { stub_endpoint(StubbableEndpoint::Routes4) }


  subject do
    described_class.new(
      api_endpoint: "http://api.example.com",
      api_token: "dummy-oauth-token",
      paas_domain: "example.com"
    )
  end

  it "returns the apps data from the api" do
    all_apps = first_page.response_body.fetch(:resources)
    all_apps += second_page.response_body.fetch(:resources)

    expect(Net::HTTP).to receive(:start).exactly(9).times.and_call_original
    expect(subject.apps).to eq(all_apps)
  end
end
