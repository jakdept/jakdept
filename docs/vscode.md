# Getting started with vscode

First point, and most important point:

Use what editor suits you.
Every damn time.

I happen to like VSCode, and this is my starter's guide for it.

## Install VSCode

There is the download page [here](https://code.visualstudio.com/download).
If you want, you can do that.
But meh I've moved away from windows because update managers should be a thing.

So use one of the below commands!

```bash
brew install vscode
```

```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders
```

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
yum check-update
sudo yum install code
```

### Launching VSCode

Once you have installed vscode, you also want to `⌘` + `shift` + `p` and run the command:
> Shell command: Install `code` command in path

This lets you install extensions from CLI.

THis also lets you open a cwd in shell in a VSCdoe window with `code .`.
Or you can add a cwd to the last selected VSCode window with `code --add .`

## Keyboard Shortcuts

Keyboard shortcuts are kindof a big point.

* `⌘` + `p` - open a file with fuzzy searching
* `⌘` + `shift` + `p` - start typing a vscode command
* `⌘` + `ctrl` + `f` - switch to full screen (or zen mode, idk, i use it only on laptop anyway)
* `⌘` + `,` - Open settings

### Panels

* `⌘` + `b` - hide/show the side panel
* `⌘` + `shift` + `e` - files explorer, shows a tree view
* `⌘` + `shift` + `f` - search for stuff across multiple files (side panel) (can also replace)
* `⌘` + `shift` + `g` - opens the git commit panel thingy
* `⌘` + `shift` + `d` - open the run and debug panel
* `ctrl` + `~` - open/hide terminal panel

### File navigation

* `⌘` + `g` - git push origin
* `⌘` + `f` - search for stuff in your current file (can also replace)
* `⌘` + `o` - fuzzy symbol search (language specific, 100x better than find)
* `⌘` + `d` - highlight next occurrence of the highlighted string (you could then c to change them all)
* `⌘` + `shift` + `d` - this one's debug, it should be highlight of all of the previous one but i should fix that sometime
* `⌘` + `r` - rename symbol (language specific, 100x better than replace)

* `⌘` + `alt` + `f` - format your current file (this also happens on save with most file times, but some extensions are dumb)

## Extensions

VSCode ships with support for Javascript built in.
Support for other languages is added with extensions.
I've listed the ones I use below, broken by language.
Honestly, most of these don't even load unless you open the filetype.

You can also paste these names into the extension pane.
Open the extension pane with `⌘` + `shift` + `x`.

Via CLI, you can install with things like:

```bash
code --install-extension <extension-name> <extension-name>

pbpaste | xargs code --install-extension
```

Or to just install everything I recommend:

```bash
curl -SsL https://raw.githubusercontent.com/jakdept/jakdept/main/dotfiles/vscode-install.list | xargs code --install-extension
```

### VSCode Theming

VSCode ships with some default themes.
To change your theme, run:

> Preferences: Color Theme

Additional themes are just extensions.
Search for theme extensions with `@category:themes`.
I use this theme myself.

```bash
code --instal-extension gerane.Theme-WarpOS
```

### Vim Mode

I am hooked on vim.
VSCode does not natively support vim keybindings.
I do miss that from Sublime.
But this extension almost makes up the gap perfectly.

```bash
code --install-extension vscodevim.vim
```

### VSCode Live Share

This extension is the second most important extension to me.
I never use it, I am sad that I do not.
It allows you to join someone else's editor.
It also allows someone else to join yours.
It's like Google Docs for VSCode.

```bash
code --install-extension ms-vsliveshare.vsliveshare
```

Do note, Vim does make this more interesting.
Also, you have to sign into Github and follow some prompts.

### GitLens

One of the big heavy VSCode extensions is GitLens.
GitLens also drastically modifies your code window, dynamically as you move.
GitLens also keeps pushing for access to Github, and Gitlab, even if you disable most of it.

* git commit history graph - `mhutchie.git-graph`
* git blame for current line - `waderyan.gitblame`

With those two extensions, and the Git support built into VSCode, I avoid `gitlens`.

### Other Extensions

I've got a ton others to go through, I will just list the rest and their use.

#### Editor Helpers

* Format a _LOT_ of stuff - `HookyQR.beautify`
* AI Powered Code completion - `GitHub.copilot`
* Per-repo cross exitor configs - `EditorConfig.EditorConfig`
* Spell checking - `zapu.vscode-aspell`
* sshfs VSCode - `ms-vscode-remote.remote-ssh-edit`
* TODO manager - `Gruntfuggly.todo-tree`
* Paste JSON into programming types - `quicktype.quicktype`

#### Application Extensions

* HTTP/REST Client - `rangav.vscode-thunder-client`
* Jira - `atlassian.atlascode`
* Github - `GitHub.vscode-pull-request-github`
* Gitlab - `GitLab.gitlab-workflow`
* Docker - `ms-azuretools.vscode-docker`
* Kubectl - `ms-kubernetes-tools.vscode-kubernetes-tools`

> Honestly, with `kubectl` and `docker` I more often just run the commands.
> But if you do not know them, the extensions can be more friendly.

#### General Format Extensions

* Lint markdown, and format on save - `DavidAnson.vscode-markdownlint`
* XML - `fabianlauer.vs-code-xml-format`
* View Excel/CSV files - `GrapeCity.gc-excelviewer`
* ERD diagrams (SQL) - `dineug.vuerd-vscode`
* Yaml:
  * Symbols - `Cronos87.yaml-symbols`
  * Convert JSON <-> Yaml - `hilleer.yaml-plus-json`
  * RedHat Yaml/Ansible/Kubernetes/Everything `redhat.vscode-yaml`
* Protobuf - `zxh404.vscode-proto3`
* SQL - `adpyke.vscode-sql-formatter` & `jakebathman.mysql-syntax`
* Hex - `ms-vscode.hexeditor`

#### Major Languages

* Go - `golang.go`
* PHP - `felixfbecker.php-intellisense`
* C/C++ - `ms-vscode.cpptools`
* Salesforce - `salesforce.salesforcedx-vscode-apex`
* Python:
  * Formatting - `ms-python.python`
  * Linting - `ms-python.vscode-pylance`
* Ruby:
  * Language - `rebornix.ruby`
  * Additional Formatting - `wingrunr21.vscode-ruby`
  * ERB support - `CraigMaslowski.erb`

#### Shell Languages

* Bash:
  * Testing - `jetmartin.bats`
  * Formatting  `foxundermoon.shell-format`
  * Linting - `timonwong.shellcheck`
* Fish shell -  `bmalehorn.vscode-fish`
* Dotenv - `mikestead.dotenv`
* jq - `jq-syntax-highlighting.jq-syntax-highlighting`
* awk - `luggage66.AWK`
* Make `twxs.cmake`
* RPMSpec `1dot75cm.RPMSpec`
* Systemd `coolbear.systemd-unit-file`

#### System Config Management Languages

* Ansible `redhat.vscode-yaml`
* Puppet - `puppet.puppet-vscode`
* Terraform - `hashicorp.terraform`
* Vagrant - `bbenoist.vagrant`
* SaltStack:
  * `korekontrol.saltstack`
  * `warpnet.salt-lint`
* Jinja - `samuelcolvin.jinjahtml`
