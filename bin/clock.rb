#!/usr/bin/env ruby
require 'clockwork'

UPDATE_TARGETS_RATE_SECONDS = ENV.fetch('UPDATE_TARGETS_RATE_SECONDS', '120').to_i

unless UPDATE_TARGETS_RATE_SECONDS >= 60
  abort "UPDATE_TARGETS_RATE_SECONDS must be greater than or equal to 60, current value #{UPDATE_TARGETS_RATE_SECONDS}"
end

module Clockwork
  handler do |job|
    system(job)
  end

  every(60, 'Update targets') {
    system("curl", "-s", "-d", "", "#{ENV.fetch('BROKER_ENDPOINT')}/update-targets")
  }
end
