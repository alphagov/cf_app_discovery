require "spec_helper"
require_relative "../load_access"

RSpec.describe "load_access" do
  describe "load_access is setup" do
    it 'returns correct contents' do
      expect(get_creds).to eq("access_name" => "test-2")
    end

    it 'does not raise an error' do
      expect { get_creds }.not_to raise_error
    end
  end

  describe "load_access targets_access not setup" do
    before {
      ENV["VCAP_SERVICES"] = '{ "user-provided": [{ "name": "test-1", "credentials": {}}]}'
    }

    it 'raises an error' do
      expect { get_creds }.to raise_error(RuntimeError, /The user-provided service has not been set up/)
    end
  end
end
