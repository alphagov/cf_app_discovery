require "json"
require "spec_helper"

RSpec.describe CfAppDiscovery::CfClient do
  include StubHelper

  subject(:client) do
    described_class.new(
      api_endpoint: "http://api.example.com",
      api_token: "dummy-oauth-token",
      paas_domain: "example.com",
    )
  end

  before do
    stub_endpoint(StubbableEndpoint::Get)
    stub_endpoint(StubbableEndpoint::GetNotFound, 404)
    stub_endpoint(StubbableEndpoint::GetForbidden, 403)
  end

  context "when everything's fine" do
    it "performs a successful get request" do
      expect(client.get("/v2/apps/test")).to eq(metadata: {}, entity: {})
    end
  end

  context "when a page cannot be found or does not exist" do
    it "fails gracefully" do
      expect { client.get("/v2/apps/not-found") }
          .to raise_error(StandardError, "404: {\"description\":\"The app could not be found: not-found\",\"error_code\":\"CF-AppNotFound\",\"code\":100004}")
    end
  end

  context "when access to a page is restricted" do
    it "fails gracefully" do
      expect { client.get("/v2/apps/forbidden-endpoint") }
          .to raise_error(StandardError, "403: {\"description\":\"You are not authorized to perform the requested action\",\"error_code\":\"CF-NotAuthorized\",\"code\":10003}")
    end
  end
end
