# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: :rubocop
RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ["--display-cop-names", "--auto-correct"]
end
