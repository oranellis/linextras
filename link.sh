#!/bin/bash

git_dir=$(dirname $(readlink -f $0))
echo $git_dir

cd $HOME/
ln -sf $git_dir/.* .
rm -rf ./.git
cd $HOME/.config/
rm $(ls $git_dir/.config/)
ln -sf $git_dir/.config/* .
