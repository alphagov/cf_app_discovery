#!/usr/bin/env ruby

require "json"

def get_creds
  json = ENV.fetch("VCAP_SERVICES")
  vcap_services = JSON.parse(json)
  user_provided = vcap_services.fetch("user-provided")
  prometheus_access = user_provided.find { |e| e["credentials"].key?("access_name") }
  targets_access_name = prometheus_access["credentials"]["access_name"] if prometheus_access

  raise "The user-provided service has not been set up." unless prometheus_access && prometheus_access["name"] == targets_access_name

  prometheus_access["credentials"]
end

if $0 == __FILE__
  get_creds.each { |k, v| print "#{k}=#{v} " }
end
