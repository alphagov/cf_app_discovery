require "rspec"
require "pry"
require "webmock/rspec"

require "stub_helper"
require "stubbable_endpoint/auth"
require "stubbable_endpoint/apps"
require "stubbable_endpoint/app"
require "stubbable_endpoint/apps_page_2"
require "stubbable_endpoint/binding"
require "stubbable_endpoint/domain_1"
require "stubbable_endpoint/domain_2"
require "stubbable_endpoint/org_1"
require "stubbable_endpoint/routes_1"
require "stubbable_endpoint/routes_2"
require "stubbable_endpoint/routes_3"
require "stubbable_endpoint/routes_4"
require "stubbable_endpoint/space_1"
require "local_manager"

require 'rack/test'

ENV["API_ENDPOINT"] = 'http://api.example.com'
ENV["UAA_ENDPOINT"] = 'http://uaa.example.com'
ENV["UAA_USERNAME"] = 'uaa-username'
ENV["UAA_PASSWORD"] = 'uaa-password'
ENV["PAAS_DOMAIN"] = 'example.com'
ENV["TARGETS_PATH"] = Dir.mktmpdir
ENV["ENVIRONMENT"] = 'local'
ENV["SERVICE_ID"] = 'fd609087-70e0-4c8c-8916-b6885ac156a3'
ENV["SERVICE_NAME"] = 'gds-prometheus-test'
ENV["PLAN_ID"] = 'b5998c91-d379-4df7-b329-11450f8459f1'
ENV["VCAP_SERVICES"] = '{ "user-provided": [{ "name": "test-1", "credentials": {}}, { "name": "test-2", "credentials": {"access_name": "test-2"}}]}'

require "cf_app_discovery"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.formatter = :doc
  config.color = true
end

FileUtils.mkdir_p("#{ENV.fetch('TARGETS_PATH')}/active")
FileUtils.mkdir_p("#{ENV.fetch('TARGETS_PATH')}/inactive")
