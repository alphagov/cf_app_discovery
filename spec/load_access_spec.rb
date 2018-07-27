require "spec_helper"
require_relative "../load_access"

RSpec.describe "load_access" do
  it 'should return correct contents' do
    expect(get_creds).to eq("access_name" => "test-2")
  end

  it 'should not raise an error' do
    expect { get_creds }.not_to raise_error
  end
end

RSpec.describe "load_access targets_access not setup" do
  before {
    ENV["VCAP_SERVICES"] = '{ "user-provided": [{ "name": "test-1", "credentials": {}}]}'
  }

  it 'should raise an error' do
    expect { get_creds }.to raise_error(RuntimeError, /The user-provided service has not been set up/)
  end
end
