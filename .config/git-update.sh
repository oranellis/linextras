#!/bin/bash

if [ -z "$1" ]; then
  commit_msg="Update $(date '+%y%m%d %H%M')"
else
  commit_msg="$*"
fi

git reset && git pull && git add -A && git commit -m "$commit_msg" && git push
