#!/bin/bash

echo "enter a project name:"
read projectname

mkdir -p $HOME/Desktop/$projectname/{img,js,css}
touch $HOME/Desktop/$projectname/{css/styles.css,js/scripts.js,index.html}
cd $HOME/Desktop/$projectname
git init
bower init
bower install bootstrap
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
atom .
exit 0
