#!/bin/bash

echo 
read -p "Enter a project name:" projectname

read -p "Enter where you want the project files to be created: [default=$HOME/Desktop]" basedir
basedir=${basedir:"$HOME/Desktop"}
echo "creating folders"
mkdir -p $basedir/$projectname/{img,js,css}
echo "creating files"
touch $basedir/$projectname/{css/styles.css,js/scripts.js,index.html}
cd $basedir/$projectname
echo "git initialization"
git init > /dev/null
yes '' | bower init >/dev/null
echo "installing bootstrap"
bower install bootstrap >/dev/null
cat >>index.html <<'EOM'
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <link href="bower_components/bootstrap/dist/css/bootstrap.css" rel="stylesheet" type="text/css">
    <script src="bower_components/jquery/dist/jquery.js"></script>
    <script src="bower_components/bootstrap/dist/js/bootstrap.js"></script>
    <script src="js/scripts.js"></script>
    <link href="css/styles.css" rel="stylesheet" type="text/css">
    <title></title>
  </head>
  <body>

  </body>
</html>

EOM
echo "opening Atom"
atom .
exit 0
