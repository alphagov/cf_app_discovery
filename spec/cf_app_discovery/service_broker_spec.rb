require "spec_helper"

RSpec.describe CfAppDiscovery::ServiceBroker do
  include Rack::Test::Methods
  include StubHelper

  let(:api_request) do
    {
      bind_resource: { app_guid: "app-1-guid" },
    }.to_json
  end

  before do
    stub_endpoint(StubbableEndpoint::Auth)
    stub_endpoint(StubbableEndpoint::App)
    stub_endpoint(StubbableEndpoint::Binding)
  end

  def app
    subject
  end

  describe "get /v2/catalog" do
    describe "when catalog api is called" do
      before do
        get "/v2/catalog"
      end

      it "returns a 200 response" do
        expect(last_response.status).to eq(200)
        body = JSON.parse(last_response.body, symbolize_names: true)
        expect(body.fetch(:services)[0].fetch(:id)).to eq('fd609087-70e0-4c8c-8916-b6885ac156a3')
      end
    end
  end

  describe "put /v2/service_instances/:id" do
    before do
      put '/v2/service_instances/:id'
    end

    it 'return a 200 response' do
      expect(last_response.status).to eq(200)
    end
  end

  describe "/v2/service_instances/:instance_id/service_bindings/:id" do
    before do
      put '/v2/service_instances/:instance_id/service_bindings/:id', api_request
    end

    it 'return a 200 response' do
      expect(last_response.status).to eq(200)
    end
  end

  describe "/v2/service_instances/:instance_id/service_bindings/:id" do
    before do
      delete "/v2/service_instances/:instance_id/service_bindings/:id", api_request
    end

    it 'return a 200 response' do
      expect(last_response.status).to eq(200)
    end
  end
end
