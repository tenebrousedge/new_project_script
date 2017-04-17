#!/bin/bash

read -p "Enter a project name:" projectname

read -p "Enter where you want the project files to be created: [default=$HOME/Desktop]" basedir
basedir=${basedir:-"$HOME/Desktop"}
echo "creating folders"
mkdir -p $basedir/$projectname/{lib,spec}
echo "creating files"

cat >Gemfile  <<'EOM'
source "https://rubygems.org"

gem 'rspec'

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'pry'
end
EOM

cat >Rakefile <<'EOM'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = ['--color', '--format', 'doc']
end
EOM

cat >Guardfile <<'EOM'
guard 'rspec' do
  # watch /lib/ files
  watch(%r{^lib/(.+).rb$}) do |m|
    "spec/#{m[1]}_spec.rb"
  end

# watch /spec/ files
  watch(%r{^spec/(.+).rb$}) do |m|
    "spec/#{m[1]}.rb"
  end
end
EOM

bundle install >/dev/null
