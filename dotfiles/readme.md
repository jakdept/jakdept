# System setup

## Primary system

These are my dotfiles.

I've used them to set up Linux and macOS systems in the past.
Most recently I've used macOS, but everything should work.

Install Brew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 
```

Install git:

```bash
brew install git
```

To clone:

```bash
git clone https://github.com/jakdept/jakdept.git ~/src/github.com/jakdept/jakdept
```

Enable TouchID sudo by copying this file:

```bash
/etc/pam.d/sudo_local.template
```

And uncommenting the line:

```pam
auth       sufficient     pam_tid.so
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
cat ~/src/github.com/jakdept/jakdept/dotfiles/brew-cask.list | xargs brew install --cask
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

```bash
cat dotfiles/vscode-install.list | xargs -L1 code --install-extension
cat dotfiles/vscode-install.list | xargs -L1 code --install-extension
```

### Add Gems

Actually just install `eyaml` but whatever.

```bash
sudo gem install hiera-eyaml
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

Install Rosetta

```bash
/usr/sbin/softwareupdate --install-rosetta --agree-to-license
```

```bash
defaults write -g ApplePressAndHoldEnabled -bool false # key repeat

defaults write com.apple.screencapture location ~/Downloads # screencapture location
defaults write com.Apple.Accessibility AccessibilityEnabled -bool False # disable accessibility stuff
defaults write com.apple.airplay showInMenuBarIfPresent -bool False
defaults write com.apple.HIToolbox AppleDictationAutoEnable -int 0

defaults write com.apple.AppleMultitouchTrackpad Clicking -bool True # tap to click
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool False # tap & retap to drag (trash)
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool True # disable force touch
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool False # disable rotate
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1 # drag with 3 fingers
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 0

defaults write com.apple.dock autohide -bool True
defaults write com.apple.dock tilesize -int 30
defaults write com.apple.dock largesize -int 70
defaults write com.apple.dock magnification -bool True
defaults write com.apple.dock show-recents -bool False
defaults write com.apple.dock showDesktopGestureEnabled -bool False
defaults write com.apple.dock showLaunchpadGestureEnabled -bool False
defaults write com.apple.dock showMissionControlGestureEnabled -bool False

defaults write com.apple.finder ShowPathbar -bool True
defaults write com.apple.finder ShowRecentTags -bool False
defaults write com.apple.finder ShowSidebar -bool True
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool False

defaults write com.apple.menuextra.clock DateFormat -string "EEE H:mm"
defaults write com.apple.menuextra.clock IsAnalog -bool False
defaults write com.apple.menuextra.clock Show24Hour -bool True
defaults write com.apple.menuextra.clock ShowDayOfMonth -bool False
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool True

# touchbar
defaults write com.apple.controlstrip MiniCustomized -array com.apple.system.brightness com.apple.system.mute com.apple.system.volume com.apple.system.media-play-pause

killall SystemUIServer
killall Dock
killall Finder
killall ControlStrip
```

### More repos to clone

```text
git@gitlab.com:openconnect/openconnect.git
https://github.com/apache/httpd.git
git@github.com:php/php-src.git
https://gitlab.com/gitlab-org/gitlab-runner.git
git://git.int.liquidweb.com/lw.git
https://github.com/torvalds/linux.git
https://github.com/opencontainers/runc
https://git.centos.org/rpms/centos-release.git
```

## Update settings

Run `update-dotfiles`.

## Secondary System

Let's be real - install fish cause it's nice, but also you just do everything in docker anyway.

Go install docker. Then:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
printf '%s ALL=(ALL) NOPASSWD: ALL\n' "$USER" | sudo tee -a /etc/sudoers
```

```
docker run -d --name tailscale --restart=unless-stopped -e UP_FLAGS="-hostname $(hostname)" --network=host deasmi/unraid-tailscale
```

```
docker run -d --name sshb0t --restart always -v ${HOME}/.ssh/authorized_keys:/root/.ssh/authorized_keys r.j3ss.co/sshb0t --user jakdept --keyfile /root/.ssh/authorized_keys
```
