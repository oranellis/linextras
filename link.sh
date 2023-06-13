#!/bin/bash

# Files to exclude from the linking step
EXCLUSIONS=".git .Xresources .gitconfig .config README.md link.sh .fehbg .gitignore"
# Files to copy to the home directory rather than link, must also be excluded above
COPIES=".Xresources .gitconfig"

# Set variables for dotfiles direcory
GIT_DIR=$(dirname "$(readlink -f $0)")

echo -e "Linking files from \033[35m$GIT_DIR\033[0m"

# Scan all files in the git direcotry
cd $HOME/
MATCHES=$(ls -A $GIT_DIR)

# Itterate through the matches
for MATCH in $MATCHES
do
if echo $EXCLUSIONS | grep -w $MATCH > /dev/null
then
	# Exclude matches present in the EXCLUSIONS variable
	echo "Skipping $MATCH"
else
	# Remove existing files (or links) and create symbolic links to the files in the git repo
	rm -r ./$MATCH
	ln -sf $GIT_DIR/$MATCH .
	echo -e "\033[32mReplaced \033[0m$MATCH"
fi
done

# Itterate through the copies variable
for COPY in $COPIES
do
	if [ ! -f $HOME/$COPY ]
	then
		# if the file doesn't already exist in the home directory then copy the file to the home folder
		cp $GIT_DIR/$COPY $HOME
		echo -e "\033[33mCopying  \033[0m$COPY"
	fi
done

# The same as above for the .config folder
cd $HOME/.config
MATCHES=$(ls -A $GIT_DIR/.config)

for MATCH in $MATCHES
do
if echo $EXCLUSIONS | grep -w $MATCH > /dev/null; then
	echo "Skipping .config/$MATCH"
else
	rm -r ./$MATCH
	ln -sf $GIT_DIR/.config/$MATCH .
	echo -e "\033[32mReplaced \033[0m.config/$MATCH"
fi
done
