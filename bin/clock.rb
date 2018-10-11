#!/usr/bin/env ruby
require 'clockwork'

module Clockwork
  handler do |job|
    system(job)
  end

  every(60, 'Update targets') {
    system("curl", "-d", "", "#{ENV.fetch('BROKER_ENDPOINT')}/update-targets")
  }
end
