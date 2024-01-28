# Dotfiles

My dotfiles for my arch i3 environment, found at `http://github.com/oranellis/i3env`

To remove and overwrite your local dotfiles with links to the files in this repo run
```
./link.sh
```

Please make a backup of your configs before running this script

## Key Repeat

To set the X11 key repeat to a sensibly fast value, add the following to ```/etc/X11/00-keyboard.conf```

```
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "AutoRepeat" "250 30"
EndSection
```
