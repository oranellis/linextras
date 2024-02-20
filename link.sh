#!/bin/bash

# Files to exclude from the linking step
EXCLUSIONS=".git README.md link.sh .gitignore backup"
# Files to copy to the home directory rather than link, must also be excluded above
COPIES=".Xresources .gitconfig"

# Set variables for dotfiles directory
GIT_DIR=$(dirname "$(readlink -f $0)")

# Function to backup existing files
backup_if_exists() {
    local file_path=$1
    local backup_dir=$2

    if [ -e "$file_path" ] && [ ! -L "$file_path" ]; then
        mkdir -p "$backup_dir"
        mv "$file_path" "$backup_dir/$(basename "$file_path").old" && echo -e "\033[33mBacked up    \033[0m$(basename "$file_path")"
    fi
}

echo -e "Linking files from \033[35m$GIT_DIR\033[0m"

# Scan all files in the git directory
cd $HOME/
MATCHES=$(ls -A $GIT_DIR)

# Iterate through the matches
for MATCH in $MATCHES; do
    if ! echo "$EXCLUSIONS $COPIES .config" | grep -w $MATCH > /dev/null; then
        # Backup existing files and create symbolic links to the files in the git repo
        backup_if_exists "./$MATCH" "$GIT_DIR/backup"
        ln -sf "$GIT_DIR/$MATCH" . && echo -e "\033[32mLinked       \033[0m$MATCH"
    fi
done

# Iterate through the copies variable
for COPY in $COPIES; do
    if [ ! -f "$HOME/$COPY" ]; then
        # if the file doesn't already exist in the home directory then copy the file to the home folder
        cp "$GIT_DIR/$COPY" "$HOME" && echo -e "\033[33mCopied       \033[0m$COPY"
    fi
done

# Handle .config directory separately
cd $HOME/.config
MATCHES=$(ls -A $GIT_DIR/.config)

for MATCH in $MATCHES; do
    if ! echo "$EXCLUSIONS $COPIES" | grep -w $MATCH > /dev/null; then
        # Backup existing files and create symbolic links to the files in the git repo
        backup_if_exists "./$MATCH" "$GIT_DIR/backup/.config"
        ln -sf "$GIT_DIR/.config/$MATCH" . && echo -e "\033[32mLinked       \033[0m.config/$MATCH"
    fi
done
