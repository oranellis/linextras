#!/bin/bash

set -e

GIT_REMOTE="$(git remote | head -n 1)"
GIT_MAIN_BRANCH="$(git remote show $GIT_REMOTE | sed -n '/HEAD branch/s/.*: //p')"

git switch $GIT_MAIN_BRANCH
git fetch -p
git pull
git branch --merged | grep -v "^\*\\|$GIT_MAIN_BRANCH" | xargs -n 1 git branch -d
