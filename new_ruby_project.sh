#!/bin/bash
set -u

read -p "Enter a project name:" projectname

read -p "Enter where you want the project files to be created: [default=$HOME/Desktop]" basedir
basedir=${basedir:-"$HOME/Desktop"}

echo "creating folders"
mkdir -p $basedir/$projectname/{views,config,db/migrate}
mkdir -p $basedir/$projectname/public/{css,js}

echo "creating files"
cd $basedir

bundle gem $projectname

cd $projectname
cat >Gemfile <<'EOM'
source 'https://rubygems.org'

ruby "2.4.0"

gem 'pg'
gem 'pry'
gem 'pry-byebug'
gem 'sinatra'
gem 'sinatra-activerecord'
gem 'sinatra-flash'

group :development do
  gem 'sinatra-contrib'
end

group :test do
  gem 'capybara'
  gem 'rspec'
  gem 'shoulda-matchers'
  gem 'timecop'
end

gemspec
EOM

cat >./views/layout.erb <<'EOM'
<!DOCTYPE html>
  <head>
  <script
  src="https://code.jquery.com/jquery-3.2.1.js"
  integrity="sha256-DZAnKJ/6XZ9si04Hgrsxu/8s717jcIzLy3oi35EouyE="
  crossorigin="anonymous"></script>
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
require 'sinatra/activerecord'
require 'sinatra-flash'

if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end

get('/') do
  erb(:index)
end
EOM

cat >config.ru <<'EOM'
require_relative './boot'
run Sinatra::Application
EOM

cat >Procfile <<'EOM'
web: bundle exec rackup config.ru -p $PORT
EOM

cat >boot.rb <<'EOM'
require 'pry-byebug'
require 'app'
require 'rake'
require 'sinatra/activerecord/rake'

env = ENV['RACK_ENV'] || 'development'
EOM

cat >.rubocop.yml <<'EOM'
Metrics/BlockLength:
  ExcludedMethods: ['describe', 'context']
EOM

cat >./config/database.yml <<EOM
development:
  adapter: postgresql
  database: ${projectname}_dev
test:
  adapter: postgresql
  database: ${projectname}_test
EOM

touch ./views/index.erb
touch ./public/{css/styles.css,js/scripts.js}

# TODO: test if rubocop is installed
rubocop -a

# if [ ! -f "$HOME/.pairs" ]; then
#     echo "You should probably create a pairs file."
# fi

if [ -f "$HOME/.pre-commit-config.yaml" ]; then
    cp "$HOME/.pre-commit-config.yaml" "./.pre-commit-config.yaml"
    pre-commit install
fi

eslint --init

echo 'Next steps: edit the .gemspec file and then run "bundle install".'
read -n1 -p "launch atom? [Y/n]" atom
shopt -s nocasematch
if [ $atom != 'n' ]; then
    atom .
fi
shopt -u nocasematch

exit 0
