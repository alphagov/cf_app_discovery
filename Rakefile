require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :lint do
  system("bundle exec govuk-lint-ruby")
end

task default: [:spec, :lint]
