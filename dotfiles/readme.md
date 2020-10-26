# System setup

These are my dotfiles.

I've used them to set up Linux and macOS systems in the past.
Most recently I've used macOS, but everything should work.


Install Brew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 
```
Install git:
```
brew install git
```

To clone:
```bash
git clone git@github.com:jakdept/jakdept.git ~/src/github.com/jakdept/jakdept
```

Install everything else from brew, and setup VSCode:
```bash
mkdir -p ~/.config/fish/conf.d ~/.config/fish/functions ~/bin
cat dotfiles/brew-install.list | xargs brew install
cat dotfiles/brew-cask-install.list | xargs brew cask install
cat dotfiles/vscode-install.list | xargs -L1 vscode --install-extension

ln ~/src/github.com/jakdept/jakdept/dotfiles/home/.config/fish/conf.d/* ~/.config/fish/conf.d/
ln ~/src/github.com/jakdept/jakdept/dotfiles/home/bin/* ~/bin/
ln ~/src/github.com/jakdept/jakdept/dotfiles/home/.config/fish/functions/fish_prompt.fish ~/.config/fish/functions/
ln ~/src/github.com/jakdept/jakdept/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/
```


