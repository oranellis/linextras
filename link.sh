#!/bin/bash

GIT_DIR=$(dirname $(readlink -f $0))
EXCLUSIONS=".git .Xresources .config README.md link.sh .fehbg"
COPIES=".Xresources"
echo $GIT_DIR

cd $HOME/
MATCHES=$(ls -A $GIT_DIR)

for MATCH in $MATCHES
do
if echo $EXCLUSIONS | grep -w $MATCH > /dev/null; then
	echo "Skipping $MATCH"
else
	rm ./$MATCH
	ln -sf $GIT_DIR/$MATCH .
	echo "replaced $MATCH"
fi
done
for COPY in $COPIES
do
	if [ ! -f $HOME/$COPY ]
	then
		cp $GIT_DIR/$COPY $HOME
		echo "$COPY missing, copying"
	fi
done


cd $HOME/.config
MATCHES=$(ls -A $GIT_DIR/.config)

for MATCH in $MATCHES
do
if echo $EXCLUSIONS | grep -w $MATCH > /dev/null; then
	echo "Skipping .config/$MATCH"
else
	rm ./$MATCH
	ln -sf $GIT_DIR/.config/$MATCH .
	echo "replaced .config/$MATCH"
fi
done
