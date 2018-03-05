require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :lint do
  system("bundle exec govuk-lint-ruby")
end

task :update_targets do
  system("./bin/cf_app_discovery")
end

task default: [:spec, :lint]
