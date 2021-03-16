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
git clone https://github.com/jakdept/jakdept.git ~/src/github.com/jakdept/jakdept
```

Install initial configs:
```bash
mkdir -p ~/.config/fish/functions ~/.config/fish/conf.d ~/bin ~/.ssh ~/Library ~/Library/Application\ Support/Code/User/
ln ~/src/github.com/jakdept/jakdept/dotfiles/home/.config/fish/functions/fish_prompt.fish ~/.config/fish/functions/
ls ~/src/github.com/jakdept/jakdept/dotfiles/home/.config/fish/conf.d | xargs -I{} ln ~/src/github.com/jakdept/jakdept/dotfiles/home/.config/fish/conf.d/{} ~/.config/fish/conf.d/
```

Install items from brew (will take a while):

```bash
cat ~/src/github.com/jakdept/jakdept/dotfiles/brew-install.list | xargs brew install
```

Switch to fish:

```bash
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

You should now have iterm. Open it and:
* Change the font to hack
* Set the default directory to ~/Downloads/
* Set window transparency
* Theme Compact
* Disable copy on pasteboard selection (General -> Selection)

### Git

```bash
brew install git-lfs
git lfs install
```

```bash
git config --global gc.reflogExpire never

git config --global init.defaultBranch main
git config --global push.default current
git config --global pull.default current
git config --global pull.rebase false
git config --global alias.count '!git shortlog -sn'

git config --global color.diff = auto
git config --global color.status = auto
git config --global color.branch = auto
git config --global color.ui = true

git config --global diff.tool = vimdiff
git config --global merge.tool = vimdiff
git config --global difftool.prompt = false
git config --global core.editor = vim
git config --global core.excludesfile = /Users/jhayhurst/.gitignore_global
```

### Setup VSCode

Install config files:
```bash
ls ~/src/github.com/jakdept/jakdept/dotfiles/home/Library/Application\ Support/Code/User/ | xargs -I{} ln ~/src/github.com/jakdept/jakdept/dotfiles/home/Library/Application\ Support/Code/User/{} ~/Library/Application\ Support/Code/User/
```

Open vscode and run `Shell Command: Install 'code' command in PATH`

```
cat dotfiles/vscode-install.list | xargs -L1 code --install-extension
```

### Add macOS App Store Packages

Sign into the app store, then:
```
awk '{print $1}' ~/src/github.com/jakdept/jakdept/dotfiles/mas-install.list | xargs -L1 mas install
```

### Add go

Install latest go:
```bash
update-go
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

### ClamAV

```bash
sudo xargs mkdir -p (find dotfiles/root -mindepth 1 -type d -print|sed 's/^dotfiles\/root//g'|sub)
ln -f dotfiles/root/usr/local/etc/clamav/freshclam.conf dotfiles/root/usr/local/etc/clamav/freshclam.conf
ln -f dotfiles/root/usr/local/etc/clamav/clamd.conf dotfiles/root/usr/local/etc/clamav/clamd.conf
sudo ln ~/src/github.com/jakdept/jakdept/dotfiles/Library/LaunchAgents/sh.brew.clamav.freshclam.plist /Library/LaunchDaemons/
sudo ln ~/src/github.com/jakdept/jakdept/dotfiles/Library/LaunchAgents/sh.brew.clamav.clamd.plist /Library/LaunchDaemons/
sudo launchctl load /Library/LaunchDaemons/sh.brew.clamav.freshclam.plist
sudo launchctl load /Library/LaunchDaemons/sh.brew.clamav.clamd.plist
```

### Firewall

```bash
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode
```

### Setup SSH key / GPG
```bash
ls ~/src/github.com/jakdept/jakdept/dotfiles/home/.gnupg|xargs -I{} ln ~/src/github.com/jakdept/jakdept/dotfiles/home/.gnupg/{} ~/.gnupg/
ls ~/src/github.com/jakdept/jakdept/dotfiles/home/.ssh|xargs -I{} ln ~/src/github.com/jakdept/jakdept/dotfiles/home/.ssh/{} ~/.ssh
```

Trust your own GPG keys:
```bash
gpg --import (curl https://github.com/jakdept.gpg|sub)
```

That should output something like:
```bash
gpg: key 0xC31FCA1B173F01B5: public key "Jack Hayhurst <jakdept@gmail.com>" imported
gpg: key 0x91BB20A6F956A176: public key "Jack Hayhurst <jhayhurst@liquidweb.com>" imported
gpg: Total number processed: 2
gpg:               imported: 2
```

Then for each:
* `gpg --edit-key <key id> trust`
* `5`
* `y`

### Add in binaries
```bash
ls ~/src/github.com/jakdept/jakdept/dotfiles/home/bin | xargs -I{} ln ~/src/github.com/jakdept/jakdept/dotfiles/home/bin/{} ~/bin/
```

### macOS modifications

Key repeat
```bash
defaults write -g ApplePressAndHoldEnabled -bool false
```

Screenshot location
```bash
defaults write com.apple.screencapture location ~/Downloads
killall SystemUIServer
```

### More repos to clone

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
