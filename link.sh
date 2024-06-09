#!/bin/bash

# Files to exclude from the linking step
EXCLUSIONS=".git README.md link.sh .gitignore .gitattributes backup"
# Files to copy to the home directory rather than link, must also be excluded above
COPIES=".gitconfig"

# Set variables for dotfiles directory
GIT_DIR=$(dirname "$(readlink -f $0)")

# Function to display help
show_help() {
	echo "Usage: $0 [mode]"
	echo "Modes:"
	echo "  link  - Creates symbolic links for files (default mode if no arguments are passed)"
	echo "  copy  - Copies files instead of linking"
	echo "  help  - Displays this help message"
	exit 0
}

# Read in mode as first arg, default to link if no arguments, show help if unknown argument
if [ $# -eq 0 ]; then
	MODE="link"
else
	case $1 in
		link)
			MODE="link"
			;;
		copy)
			MODE="copy"
			;;
		help)
			show_help
			;;
		*)
			echo "Unknown argument: $1"
			show_help
			;;
	esac
fi

# Function to backup existing files
backup_if_exists() {
	local file_path=$1
	local backup_dir=$2
	local mode=$3

	if [ -e "$file_path" ] && [ ! -L "$file_path" ] && [ "$MODE" == "link" ]; then
		mkdir -p "$backup_dir"
		mv "$file_path" "$backup_dir/$(basename "$file_path").old" && echo -e "\033[33mSaved   \033[0m$(basename "$file_path")"
	fi
}

link_or_copy() {
    local file=$1
    local destination=$2
    if [ "$MODE" = "copy" ]; then
        # Check if destination is a symbolic link and remove it if it is
        if [ -L "$destination" ]; then
            rm "$destination" && echo -e "\033[31mRemoved \033[0m$(basename "$destination") link"
        fi
		if [ ! -e "$destination" ]; then
			cp -r "$file" "$destination" && echo -e "\033[33mCopied  \033[0m$(basename "$file")"
		fi
    else
        mkdir -p "$(dirname "$destination")"
        ln -sfn "$file" "$destination" && echo -e "\033[32mLinked  \033[0m$(basename "$file")"
    fi
}

echo -e "Processing files from \033[35m$GIT_DIR\033[0m"

# Scan all files in the git directory
cd $HOME/
MATCHES=$(ls -A $GIT_DIR)

# Iterate through the matches
for MATCH in $MATCHES; do
	if ! echo "$EXCLUSIONS $COPIES .config" | grep -w $MATCH > /dev/null; then
		# Backup existing files and then link or copy
		backup_if_exists "./$MATCH" "$GIT_DIR/backup" "$MODE"
		link_or_copy "$GIT_DIR/$MATCH" "./$MATCH"
	fi
done

# Iterate through the copies variable specifically for copying
for COPY in $COPIES; do
	if [ ! -f "$HOME/$COPY" ]; then
		# Copy the file to the home folder
		cp "$GIT_DIR/$COPY" "$HOME" && echo -e "\033[33mCopied  \033[0m$COPY"
	fi
done

# Handle .config directory separately
mkdir -p $HOME/.config
cd $HOME/.config
MATCHES=$(ls -A $GIT_DIR/.config)

for MATCH in $MATCHES; do
	if ! echo "$EXCLUSIONS $COPIES" | grep -w $MATCH > /dev/null; then
		# Backup existing files and then link or copy
		backup_if_exists "./$MATCH" "$GIT_DIR/backup/.config" "$MODE"
		link_or_copy "$GIT_DIR/.config/$MATCH" "./$MATCH"
	fi
done
