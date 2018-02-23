require "rspec"
require "pry"
require "webmock/rspec"

require "stub_helper"
require "stubbable_endpoint/auth"
require "stubbable_endpoint/apps"
require "stubbable_endpoint/app"
require "stubbable_endpoint/binding"
require "stubbable_endpoint/apps_page_2"

require 'rack/test'

ENV["API_ENDPOINT"] = 'http://api.example.com'
ENV["UAA_ENDPOINT"] = 'http://uaa.example.com'
ENV["UAA_USERNAME"] = 'uaa-username'
ENV["UAA_PASSWORD"] = 'uaa-password'
ENV["PAAS_DOMAIN"] = 'example.com'
ENV["TARGETS_PATH"] = Dir.mktmpdir

require "cf_app_discovery"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.formatter = :doc
  config.color = true
end
