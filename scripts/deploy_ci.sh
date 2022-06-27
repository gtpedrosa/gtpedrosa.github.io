#!/bin/bash
set -e

echo "* checking out the master branch:"
git clone --single-branch --branch master git@github.com:gtpedrosa/gtpedrosa.github.io.git master

echo "* synchronizing the files:"
rsync -arv /src/public/ master --delete --exclude ".git"
cp README.md master/

echo "* pushing to master:"
cd master
echo "cd OK"
git config user.name "CircleCI"
git config user.email "guilherme.pedrosa@gmail.com"
echo "git config OK"
git add -A
echo "git add OK"
git commit -m "Automated deployment job ${CIRCLE_BRANCH} #${CIRCLE_BUILD_NUM}" --allow-empty
echo "git commit OK"
git push origin master

echo "* done"
