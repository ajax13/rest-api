#!/usr/bin/env bash

REPOSITIRY="https://github.com/ajax13/rest-api.git"
BRANCH="master"

#Check if we are inside a git work tree
git rev-parse --is-inside-work-tree

git config remote.origin.url $REPOSITIRY

#Get all tags and force progress reporting
git fetch --tags --progress $REPOSITIRY origin $BRANCH

echo "[pull code] update code from bitbucket repository"
git pull origin master

echo "[composer install] check package to install"
composer install --no-dev --optimize-autoloader

#echo "[validate doctrine schema]"
#php app/console doctrine:schema:validate
#php app/console doctrine:ensure-production-settings

#echo "[update database]"
#php app/console doctrine:schema:update --dump-sql --force

#php app/console innova:dev-fixtures:load

php app/console assets:install --symlink --relative

php app/console assetic:dump --env=prod --no-debug

php app/console cache:clear --env=prod --no-debug --no-warmup
#
#echo "[modify permissions] cache and log"
#sudo chmod -R 777 app/cache/
#sudo chmod -R 777 app/logs/

bower install

echo '
                   _____
          (__)    /     \
          (@o)   ( Done! )
   /-------\/ --" \_____/
  / |     ||
*  ||----||
   ^^    ^^
'



