require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :lint do
  system("bundle exec rubocop")
end

task default: %i[spec lint]
