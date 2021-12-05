+++
title = "Migrating CI tool from travis to circleci for hugo blog on ghpages"
author = ["Guilherme Pedrosa"]
date = 2021-12-05T09:11:00-03:00
tags = ["dev", "ops", "hugo", "ghpages", "circleci"]
draft = false
+++

When Travis CI was acquired by Idera, it didn't take long to cease its support for open source projects. This affected this blog since I overengineered it to learn some dev-ops skills. As result, I was forced to migrate the continuous integration (CI) tool from Travis to CircleCI. While I was at it, I took advantage and included a docker image for the build instead of declaring the dependencies installation as part of the CI build.

I am indebted to [z0li](https://github.com/z0li/hugo-builder) who provided a guide I was able to follow through [here.](https://z0li.github.io/deliver-static-sites-with-hugo-circleci-github/) The Docker image, config.yml and deploy scripts were modified from z0li's post.


## 1.Docker Image {#1-dot-docker-image}

This is the base Docker image upon which the blog is built. It still contains htmlproofer even though I am not using it at the moment. It is something either I'll adopt or drop in the future. It also contains, of course, hugo version 0.68.1 which is the last one I troubleshooted the cocoa theme for as detailed in my [previous post.](https://gtpedrosa.github.io/blog/upgrading-an-outdated-hugo-template/)

```Dockerfile
FROM ruby:2.6-alpine3.9

ENV HUGO_VERSION=0.68.1

RUN apk add --no-cache make gcc libc-dev bash libcurl ruby-nokogiri \
      openssh-client rsync git && \
    gem install --no-document html-proofer

RUN mkdir /tmp/hugo && \
    cd /tmp/hugo && \
    wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    tar xzvf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    mv /tmp/hugo/hugo /usr/local/bin/ && \
    rm -rf /tmp/hugo

CMD [ "hugo", "version" ]
```


## 2. config.yml {#2-dot-config-dot-yml}

This is where most of the action happens, the **config.yml** file required by CircleCI.

```config.yml
version: 2.1
jobs:
  build:
    docker:
      - image: gtpedrosa/hugo-build:latest
    working_directory: /src
    steps:
      - add_ssh_keys:
	  fingerprints:
	    - "x4TBLAoCPktmU+ECc3aoxBPuymLldWBEaFpnR8yFDdE"
      - checkout
      - run: git submodule update --init
      - run: hugo -v -s /src -d /src/public
      - deploy:
	  name: push to master branch
	  command: sh /src/scripts/deploy_ci.sh
```

Notice:

-   docker: it pulls the image previously uploaded to dockerhub and [linked to my github repo.](https://github.com/gtpedrosa/hugo-build/blob/master/Dockerfile)
-   working\_directory: specify the location to work from
-   add\_ssh\_keys: include necessary credentials so circleci communicates to github
-   checkout: special command to checkout the gtpedriosa.github.io repo
-   first run: update submodules, in this case, the hugo theme used and [fork that I mantain](https://github.com/gtpedrosa/cocoa-hugo-theme), but designed by Nishanth Shanmugham
-   second run: after pulling the code it runs hugo and saves the html in the usual **public** folder
-   deploy: calls deploy script where the rest of action happens, which I'll document in the following section.


## 3. deploy\_ci.sh {#3-dot-deploy-ci-dot-sh}

Admitedly, I made inumerous mistakes in this transition. And learned a lot by trial and error, so here's the full file:

```deploy_ci.sh
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
git commit -m "Automated deployment job ${CIRCLE_BRANCH} #${CIRCLE_BUILD_NUM} [skip ci]" --allow-empty
echo "git commit OK"
git push origin master

echo "* done"
```

Now, let's break it down in three parts and make some comments.

```p1
set -e
```

The first excerpt causes the execution of the script to fail if an error is raised, instead of the default behavior of ignoring it. Therefore, any issues in the deployment will cause the build to fail.

```p2
echo "* checking out the master branch:"
git clone --single-branch --branch master git@github.com:gtpedrosa/gtpedrosa.github.io.git master

echo "* synchronizing the files:"
rsync -arv /src/public/ master --delete --exclude ".git"
cp README.md master/
```

The html files in the master branch are cloned in this second part. The generated html pages from the hugo run (refer to the second run statement in the _config.yml_ file) are synced to the folder where the html files were cloned. Notice where they are coming from in the rsync argument. This is basically where the new posts are added to the previous ones.

```p3
echo "* pushing to master:"
cd master
echo "cd OK"
git config user.name "CircleCI"
git config user.email "guilherme.pedrosa@gmail.com"
echo "git config OK"
git add -A
echo "git add OK"
git commit -m "Automated deployment job ${CIRCLE_BRANCH} #${CIRCLE_BUILD_NUM} [skip ci]" --allow-empty
echo "git commit OK"
git push origin master

echo "* done"
```

Lastly, the changes are commited and pushed to master. This will update the ghpages site automatically. One detail to note is the _[skip ci]_ tag. From the documentation:

> By default, CircleCI automatically triggers a pipeline whenever you push changes to your project. You can override this behavior by adding a [ci skip] or [skip ci] tag within the first 250 characters of the body or title of the commit.

If you ommit it, another job will be triggered and fail. This is messing up with the badge in the readme of the repository at this exact moment.

Also, any issue in the build can be debugged in the newly spun environment by [sshing in an interactive shell.](https://circleci.com/docs/2.0/ssh-access-jobs/) I really appreciated this to understand where I messed up with my paths.

Well, I hope this breakdown distilled some of the learnings in the process.