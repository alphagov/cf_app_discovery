require 'json'
require "spec_helper"

RSpec.describe CfAppDiscovery::AppInfoConfigurer do
  class FakeClient
    def get(path)
      path_hash = {
        "/v2/apps/sample_guid/routes" => {
          resources: [],
        },
        "/v2/shared_domains" => {
          resources: [{
            metadata: {
              url: "sample_private_domain_url"
              },
            entity: {
              name: "apps.internal",
              internal: true
              }
            }],
        },
        "/v2/apps/sample_guid_with_host/routes" => {
          resources: [{
            entity: {
              domain_url: "sample_domain_url",
              host: "sample_host",
              path: ""
            }
          }]
        },
        "/v2/apps/sample_guid_with_path/routes" => {
          resources: [{
            entity: {
              domain_url: "sample_domain_url",
              host: "",
              path: "/sample_path"
            }
          }]
        },
        "/v2/apps/sample_guid_with_host_and_path/routes" => {
          resources: [{
            entity: {
              domain_url: "sample_domain_url",
              host: "sample_host",
              path: "/sample_path"
            }
          }]
        },
        "/v2/apps/sample_guid_with_private_and_public_resources/routes" => {
          resources: [
            {
              entity: {
                domain_url: "sample_private_domain_url",
                host: "private_host",
                path: "/sample_private_path"
              }
            },
            {
            entity: {
              domain_url: "sample_domain_url",
              host: "public_host",
              path: "/sample_public_path"
            }
          }
        ]
        },
        "/v2/apps/sample_guid_without_host/routes" => {
          resources: [{
            entity: {
              domain_url: "sample_domain_url",
              host: "",
              path: ""
            }
          }]
        },
        "sample_domain_url" => {
          entity: {
            name: "sample_name.com"
          }
        },
        "sample_private_domain_url" => {
          entity: {
            name: "apps.internal",
            internal: true
          },
          metadata: {
            url: "sample_private_domain_url"
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

  subject(:app_info_configurer) do
    described_class.new(
      api_endpoint: "http://api.example.com",
      api_token: "dummy-oauth-token",
      paas_domain: "example.com"
    )
  end

  before do
    app_info_configurer.client = FakeClient.new
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
    let(:resource_with_path) {
      {
        metadata: {
          guid: "sample_guid_with_path"
        },
        entity: {
          domain_url: "sample_domain_url"
        }
      }
    }
    let(:resource_with_host_and_path) {
      {
        metadata: {
          guid: "sample_guid_with_host_and_path"
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
    let(:resource_with_private_and_public) {
      {
        metadata: {
          guid: "sample_guid_with_private_and_public_resources"
        },
        entity: {
          name: "app-name",
          domain_url: "sample_domain_url"
        }
      }
    }

    context "when resources field is nil" do
      it "sets a hostname on the input resource" do
        app_info_configurer.set_first_route(resource)
        expect(resource[:hostname]).to eq("test_name.example.com")
        expect(resource[:path]).to eq("")
      end
    end

    context "when resources field includes host" do
      it "sets a hostname on the input resource" do
        app_info_configurer.set_first_route(resource_with_host)
        expect(resource_with_host[:hostname]).to eq("sample_host.sample_name.com")
        expect(resource_with_host[:path]).to eq("")
      end
    end

    context "when resources field includes path" do
      it "sets a hostname and path on the input resource" do
        app_info_configurer.set_first_route(resource_with_path)
        expect(resource_with_path[:hostname]).to eq("sample_name.com")
        expect(resource_with_path[:path]).to eq("/sample_path")
      end
    end

    context "when resources field includes host and path" do
      it "sets a hostname and path on the input resource" do
        app_info_configurer.set_first_route(resource_with_host_and_path)
        expect(resource_with_host_and_path[:hostname]).to eq("sample_host.sample_name.com")
        expect(resource_with_host_and_path[:path]).to eq("/sample_path")
      end
    end

    context "when resources field does not include host" do
      it "sets a hostname on the input resource" do
        app_info_configurer.set_first_route(resource_without_host)
        expect(resource_without_host[:hostname]).to eq("sample_name.com")
        expect(resource_without_host[:path]).to eq("")
      end
    end

    context "when resources include private and public routes" do
      it "uses the first available public route" do
        app_info_configurer.set_first_route(resource_with_private_and_public)
        expect(resource_with_private_and_public[:hostname]).to eq("public_host.sample_name.com")
        expect(resource_with_private_and_public[:path]).to eq("/sample_public_path")
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
      app_info_configurer.set_space_and_org(resource_org_and_space)
      expect(resource_org_and_space[:org]).to eq("example_org_name")
      expect(resource_org_and_space[:space]).to eq("example_space_name")
    end
  end
end
