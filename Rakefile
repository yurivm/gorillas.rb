$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))

require "rspec/core/rake_task"
require "rubocop/rake_task"
require "reek/rake/task"

RSpec::Core::RakeTask.new(:spec)

desc "Run Reek"
Reek::Rake::Task.new

desc "Run RuboCop"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ["--display-cop-names"]
end

task quality: %i(rubocop reek)
task default: [:spec, :quality]
