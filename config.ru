$LOAD_PATH.unshift("lib")

require "cf_app_discovery"

run CfAppDiscovery::ServiceBroker
