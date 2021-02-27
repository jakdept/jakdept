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
mkdir -p ~/.config/fish/functions ~/bin
ln ~/src/github.com/jakdept/jakdept/dotfiles/vscode/settings.json '~/Library/Application Support/Code/User/'
ln -s ~/src/github.com/jakdept/jakdept/dotfiles/home/.config/fish/conf.d ~/.config/fish/conf.d
ln ~/src/github.com/jakdept/jakdept/dotfiles/home/.config/fish/functions/fish_prompt.fish ~/.config/fish/functions/

ls dotfiles/home/bin | xargs -I{} ln {} ~/bin/

cat dotfiles/brew-install.list | xargs brew install
cat dotfiles/vscode-install.list | xargs -L1 vscode --install-extension
```

Some other things to install:

```bash
go get \
github.com/jakdept/clapback \
github.com/rakyll/hey \
github.com/davecheney/httpstat \
github.com/Yash-Handa/logo-ls \
github.com/clarkwang/passh \
github.com/mvdan/sh/cmd/shfmt \
github.com/jessfraz/udict \
github.com/jakdept/spongebob
```

Some git repos I'll want:

```
https://github.com/apache/httpd.git
git@github.com:php/php-src.git
https://gitlab.com/gitlab-org/gitlab-runner.git
git://git.int.liquidweb.com/lw.git
https://github.com/torvalds/linux.git
https://github.com/opencontainers/runc
https://git.centos.org/rpms/centos-release.git
```

## Update settings
Keep this up to date.

Update VSCode extensions:
```bash
code --list-extensions > dotfiles/vscode-install.list
```

Update Brew stuff:
```bash
brew list > dotfiles/brew-install.list
```
