require "rspec"
require "pry"
require "webmock/rspec"

require "stub_helper"
require "stubbable_endpoint/auth"
require "stubbable_endpoint/apps"
require "stubbable_endpoint/apps_page_2"

require "cf_app_discovery"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.formatter = :doc
  config.color = true
end
