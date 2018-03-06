#!/usr/bin/env ruby
require 'clockwork'

module Clockwork
  handler do |job|
    system(job)
  end

  every(300, 'Update targets') {
    `rake update_targets`
  }
end
