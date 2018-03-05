#!/usr/bin/env ruby
require 'clockwork'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(10, 'frequent.job')
end
