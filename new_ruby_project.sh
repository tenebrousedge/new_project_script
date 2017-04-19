#!/bin/bash
set -u

read -p "Enter a project name:" projectname

read -p "Enter where you want the project files to be created: [default=$HOME/Desktop]" basedir
basedir=${basedir:-"$HOME/Desktop"}

echo "creating folders"
mkdir -p $basedir/$projectname/{lib,spec,views}

echo "creating files"
cd $basedir/$projectname
cat >Gemfile  <<'EOM'
source "https://rubygems.org"

gem 'rspec'
gem 'sinatra'
gem 'sinatra-contrib'

group :development do
  gem 'pry'
  gem 'capybara'
end
EOM

cat >Rakefile <<'EOM'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = ['--color', '--format', 'doc']
end
EOM

cat >./view/layout.erb <<'EOM'
<!DOCTYPE html>
  <head>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
EOM

cat >app.rb <<'EOM'
require 'sinatra'
require "sinatra/reloader" if development?

get('/') do
  erb(:index)
end
EOM

touch ./view/index.erb

bundle install >/dev/null &
git init
if [ ! -f "$HOME/.pairs"]; then
  nano "$HOME/.pairs"
fi

atom .
