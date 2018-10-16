require 'json'
require "spec_helper"

RSpec.describe CfAppDiscovery::Banana do
  class FakeClient
    def get(path)
      path_hash = {
        "/v2/apps/sample_guid/routes" => {
          resources: [],
        },
        "/v2/apps/sample_guid_with_host/routes" => {
          resources: [{
            entity: {
              domain_url: "sample_domain_url",
              host: "sample_host"
            }
          }]
        },
        "/v2/apps/sample_guid_without_host/routes" => {
          resources: [{
            entity: {
              domain_url: "sample_domain_url",
              host: ""
            }
          }]
        },
        "sample_domain_url" => {
          entity: {
            name: "sample_name.com"
          }
        },
        "example_space.gov.uk" => {
          entity: {
            name: "example_space_name",
            organization_url: "example_org.gov.uk"
          }
        },
        "example_org.gov.uk" => {
          entity: {
            name: "example_org_name"
          }
        }
      }
      path_hash[path]
    end

    def routes(path)
      get("/v2/apps/#{path}/routes")
    end
  end

  subject(:banana) do
    described_class.new(
      api_endpoint: "http://api.example.com",
      api_token: "dummy-oauth-token",
      paas_domain: "example.com"
    )
  end

  before do
    banana.client = FakeClient.new
  end

  describe "set_first_route" do
    let(:resource) {
      {
        metadata: {
          guid: "sample_guid"
        },
        entity: {
          name: "test_name"
        }
      }
    }
    let(:resource_with_host) {
      {
        metadata: {
          guid: "sample_guid_with_host"
        },
        entity: {
          domain_url: "sample_domain_url"
        }
      }
    }
    let(:resource_without_host) {
      {
        metadata: {
          guid: "sample_guid_without_host"
        },
        entity: {
          domain_url: "sample_domain_url"
        }
      }
    }

    context "when resources field is nil" do
      it "sets a route on the input resource" do
        banana.set_first_route(resource)
        expect(resource[:route]).to eq("test_name.example.com")
      end
    end

    context "when resources field includes host" do
      it "sets a route on the input resource" do
        banana.set_first_route(resource_with_host)
        expect(resource_with_host[:route]).to eq("sample_host.sample_name.com")
      end
    end

    context "when resources field does not include host" do
      it "sets a route on the input resource" do
        banana.set_first_route(resource_without_host)
        expect(resource_without_host[:route]).to eq("sample_name.com")
      end
    end
  end

  describe "set_space_and_org" do
    let(:resource_org_and_space) {
      {
        entity: {
        space_url: "example_space.gov.uk"
        }
      }
    }

    it "sets the org and space" do
      banana.set_space_and_org(resource_org_and_space)
      expect(resource_org_and_space[:org]).to eq("example_org_name")
      expect(resource_org_and_space[:space]).to eq("example_space_name")
    end
  end
end
