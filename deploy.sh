#!/usr/bin/env bash

set -e

hugo
cp public/index.xml public/feed.xml

if [[ -d public/.git ]]; then
  git -C public git fetch
  git -C public git reset --soft origin/master
else
  git clone -n -b --single-branch master git@github.com:LKI/lki.github.io.git .deploy
  mv .deploy/.git public
fi

git -C public git add .
git -C public git commit -m "chore: auto build from hugo"
git -C public git push -u origin master
