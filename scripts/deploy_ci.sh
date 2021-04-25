#!/bin/bash
set -e

echo "* checking out the master branch:"
git clone --single-branch --branch code git@github.com:gtpedrosa/gtpedrosa.github.io.git

echo "* synchronizing the files:"
rsync -arv public/ master --delete --exclude ".git"
cp README.md master/

echo "* pushing to master:"
cd master
echo "cd OK"
git config user.name "CircleCI"
git config user.email ${GIT_EMAIL}
echo "git config OK"
git add -A
echo "git add OK"
git commit -m "Automated deployment job ${CIRCLE_BRANCH} #${CIRCLE_BUILD_NUM} [skip ci]" --allow-empty
echo "git commit OK"
git push origin master

echo "* done"
