# Dotfiles
My dotfiles for my arch i3 environment, found at `http://github.com/oranellis/i3env`

To link the local dotfiles to this repo run
```
cd ~/
ln -sf ~/.config/dotfiles/.*[!config][!git] .
cd ~/.config/
rm $(ls ~/.config/dotfiles/.config/)
ln -sf ~/.config/dotfiles/.config/* .

```
