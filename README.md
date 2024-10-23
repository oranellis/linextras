# Dotfiles

My dotfiles for my Arch Linux Hyprland environment, found at `http://github.com/oranellis/dotfiles`

To set up the hyprland environment 

To remove and overwrite your local dotfiles with links to the files in this repo run
```
./link.sh
```
This will back up existing configurations to a `backup/` directory in this git repo (WARNING backups may be overwritten if the script is run several times).

To copy the files from this git repo to your local config, run the following instead
```
./link.sh copy
```
Existing files will not be overwritten in copy mode.

## Versions

Requires:
- bash - 4.0+

Optional:
- nvim - 0.9.0+
- hyprland - 0.40.0+
- tmux - 3.4+
- waybar - 0.10.0+
- wofi - 1.4.0+
- alacritty - 0.12.0+
- swaync - 0.10.1+
- polkit-kde-agent - 6.1.5+
