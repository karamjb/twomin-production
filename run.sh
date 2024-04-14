#!/bin/bash
echo Navigate to project folder

echo "*** *** *** ***     *** *** *** *** *** ***"
echo "                ***                        "
echo "*** *** *** ***     *** *** *** *** *** ***"
echo "                ***                        "
echo "*** *** *** ***     *** *** *** *** *** ***"
echo "                ***                        "

echo Navigate to project folder
cd /var/www/twomin

echo Reset Branch
git checkout -- .

echo Fetching New Version
git checkout production
git pull

echo Removeing The Old Version
cd /var/www/twomin
rm -rf ./core/build
rm -rf ./consumer/build
rm -rf ./common/build

echo Setting env
export BACKEND_BASE_URL=https://api-app.soonx.co.il/api/

echo Prepare the common library
cd /var/www/twomin/common
npm install
npm run build

echo Start Deploy Core
cd /var/www/twomin/core
npm install
npm run build

echo Start Deploy Frontend
cd /var/www/twomin/frontend
npm install
npm run build

echo Start Deploy Consumer
cd /var/www/twomin/consumer
npm install
npm run build

echo Stoping twomin
pm2 stop twomin-core
pm2 stop twomin-frontend
pm2 stop twomin-consumer

echo Go Live
cd /var/www/twomin-production
pm2 start production.config.js
