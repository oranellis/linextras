# Dotfiles

My dotfiles for my archlinux i3 environment, found at `http://github.com/oranellis/i3env`

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

## Key Repeat

To set the X11 key repeat to a sensibly fast value, add the following to ```/etc/X11/xorg.conf.d/00-keyboard.conf```

```
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "gb"
    Option "AutoRepeat" "250 30"
EndSection
```
