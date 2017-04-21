#!/bin/bash
set -u

read -p "Enter a project name:" projectname

read -p "Enter where you want the project files to be created: [default=$HOME/Desktop]" basedir
basedir=${basedir:-"$HOME/Desktop"}

echo "creating folders"
mkdir -p $basedir/$projectname/views

echo "creating files"
cd $basedir

bundle gem $projectname

cd $projectname
cat >Gemfile <<'EOM'
source 'https://rubygems.org'

gem 'sinatra'
gem 'capybara'

group :development do
  gem 'pry'
  gem 'sinatra-contrib'
end
gemspec
EOM

bundle install

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
if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end

get('/') do
  erb(:index)
end
EOM

touch ./views/index.erb

bundle install >/dev/null &
git init
if [ ! -f "$HOME/.pairs"]; then
  nano "$HOME/.pairs"
fi

atom .
