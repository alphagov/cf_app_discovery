require 'json'
require "spec_helper"

RSpec.describe CfAppDiscovery::Client do
  include StubHelper

  spec_root = File.dirname __dir__
  expected_responses_file = File.read("#{spec_root}/fixtures/expected_responses.json")
  expected_responses = JSON.parse(expected_responses_file, symbolize_names: true)

  before do
    stub_endpoint(first_page)
    stub_endpoint(second_page)
    stub_endpoint(StubbableEndpoint::Domain1)
    stub_endpoint(StubbableEndpoint::Domain2)
    stub_endpoint(StubbableEndpoint::Org1)
    stub_endpoint(StubbableEndpoint::Routes1)
    stub_endpoint(StubbableEndpoint::Routes2)
    stub_endpoint(StubbableEndpoint::Routes3)
    stub_endpoint(StubbableEndpoint::Routes4)
    stub_endpoint(StubbableEndpoint::Space1)
  end

  subject(:client) do
    described_class.new(
      api_endpoint: "http://api.example.com",
      api_token: "dummy-oauth-token",
      paas_domain: "example.com"
    )
  end

  let(:first_page) { StubbableEndpoint::Apps }
  let(:second_page) { StubbableEndpoint::AppsPage2 }

  it "returns the apps data from the api" do
    first_page.response_body.fetch(:resources)
    second_page.response_body.fetch(:resources)

    expect(client.apps).to eq(expected_responses)
  end
end
