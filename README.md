# My Mac Setup

When a new major version of MacOS comes out, i reinstall everything and follow this repo. 

## About Me

I'm a musician, developer & youtuber. <br>
I'm the Creator of [KeyCapture](https://keycapture.app) on the Apple App Store.<br>
Subscribe to my YouTube Channel: [JDMusiq](https://youtube.com/jdmusiq).

Repo Inspired by: [CodingGarden/mac-setup](https://github.com/CodingGarden/mac-setup) - [YouTube Vid](https://www.youtube.com/watch?v=2_ZbslLnshw)

## My Mac

M4 Max Macbook Pro, 16-inch, 2024<br>
4 Efficiency, 12 Performance Cores<br>
128 GB Unified Memory<br>
Current OS: Tahoe 26.1

## 3 Screen setup
Docking Station: [StarTech USB-C 4K Triple Monitor Docking Station](https://www.amazon.com/gp/product/B07LGR8Y14)
Monitors: 
- 3x [Sceptre 32 inch QHD IPS Monitor HDR400 2560x1440 DisplayPort up to 144Hz](https://www.amazon.com/dp/B08VTW474P?psc=1&ref=ppx_yo2ov_dt_b_product_details)

# Table of Contents

- Xcode Command Line Tools
- Homebrew / Terminal / Shell
- Install everything via Brewfile
- Git Config
- Finder Settings
- Menu Bar Customization
- Node.js
  - Globals: yarn / pnpm / expo-cli
- Bun
- AI Stack
- Mac Disk Cleanup

## Xcode Command Line Tools
Install Xcode and run this first so that the system doesnt ask you later

```sh
xcode-select --install
```

## Homebrew / Terminal / Shell 

### Homebrew

[Homebrew](https://brew.sh/) - the macos package manager

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Terminal

Currently using cmux (built on Ghostty's lib, but i like it better). Tried Ghostty, Warp, and iTerm in the past. iTerm i've retired completely. Warp I liked the AI features, but i rarely used them.

Installed via the `Brewfile` step below — no extra command needed.

### Shell

Reference: [Link](https://ohmyz.sh/#install)

```sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
#### USE POWER LEVEL 10k ####
[Link](https://github.com/romkatv/powerlevel10k)
Make it look like this:

![Power Level 10k image](https://github.com/jasondavis87/mac-setup/blob/main/10k.png?raw=true)

## Install everything via Brewfile

One command installs every formula, cask, Mac App Store app, and VS Code extension listed in `Brewfile`:

```sh
brew bundle --file=Brewfile
```

To regenerate `Brewfile` after manual installs/uninstalls:

```sh
brew bundle dump --force --describe --file=Brewfile
```

#### App Selection notes:
- Spotlight Repalcement: I used to use alfred, now I use raycast exclusively.
- Alt-tab: I used to use alt-tab, but trying without this year. The default ones seems good enough. We'll see.
- Discord: I've switched to Legcord. No particular reason other than it was suggested.
- Stats: i tried `stats` for a year and it was OK. I went back to iStatMenus having a license already.
- Scroll-reverser: I personally scroll my mouse backwards ane use my trackpad normally. So this helps with that. 
- Cursor is my IDE of choice although i also have VSCode as a backup.

## Enable Brew auto upgrades

### 1. Create the Launch script

```sh
mkdir -p ~/Library/LaunchAgents
cat > ~/Library/LaunchAgents/com.user.brew-auto-update.plist <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.user.brew-auto-update</string>

    <key>ProgramArguments</key>
    <array>
      <string>/bin/zsh</string>
      <string>-lc</string>
      <string>/opt/homebrew/bin/brew update --quiet && /opt/homebrew/bin/brew upgrade --greedy --quiet && /opt/homebrew/bin/brew cleanup --prune=7 --quiet</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
      <key>Hour</key>
      <integer>3</integer>
      <key>Minute</key>
      <integer>0</integer>
    </dict>

    <key>StandardOutPath</key>
    <string>/tmp/brew-auto-update.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/brew-auto-update.err</string>

    <key>Nice</key>
    <integer>10</integer>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
XML
```

### 2. Load it

```sh
launchctl load ~/Library/LaunchAgents/com.user.brew-auto-update.plist
launchctl start com.user.brew-auto-update
```

### (Unload it if needed)
```sh
launchctl unload ~/Library/LaunchAgents/com.user.brew-auto-update.plist
```

## Git Config

```sh
git config --global user.email "YOUR_EMAIL"
git config --global user.name "YOUR NAME"
git config --global core.editor "nano"
```

#### Regenerate SSH Keys and Save

Follow instructions here: [https://docs.github.com/en/authentication/connecting-to-github-with-ssh](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)


### Hetzner

Now's a good time to update your hetzner servers with the new ssh key from the Hetzner console.
Do this from Hetzner.com or the coolify services running on the servers.

## Finder Settings

### Settings - General
- Show these itesm on the desktop --> UNCHECK ALL
- New Finder Windows Show --> Home Directory

### Settings - Advanced
- Check Show All filename extensions
- When performing a search: --> Search the Current Folder

### Settings - Sidebar (Fix Favorites)
- Add Development Folder
- Remove Recents
- Add Music
- Add Pictures
- Add Home (also move to top)

### Menu - View 
- Show Status Bar
- Show Path Bar

## Menu Bar Customizations

## Node.js w/ yarn/expo-cli

Install Node Version Manager and Yarn/pnpm/expo for each version

Repo Link: [GitHub](https://github.com/nvm-sh/nvm)

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

```sh
nvm install --default 24
nvm use 24
npm install -g yarn
npm install -g pnpm
npm install -g expo-cli

nvm install 22
nvm use 22
npm install -g npm@11.6.2
npm install -g yarn
npm install -g pnpm
npm install -g expo-cli
```


## Additional Applications

### Mac App Store Programs

Use [mas](https://github.com/mas-cli/mas) to download everything

Sign In First: 
```sh
open /System/Applications/App\ Store.app
```
Then
```sh
mas install 634148309 899247664 497799835
```
This Installs:
- Logic Pro
- TestFlight
- Xcode

(These are also in `Brewfile`, so `brew bundle` handles them too once you're signed into the App Store.)

### Other Programs
- Waves Central
- Omnisphere
- Komplete 11
- Microsoft Office
- Ableton Live 12 (in brew cask - register it)
- iStatMenu
- Register iStat Menu (save on dropbox)


## ohMyZSH

### .zshrc

```sh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git node vscode)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
```

### .zprofile
```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
fortune | cowsay -f tux
source ~/.nvm/nvm.sh
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
```

### .p10k.zsh
Replace:
```
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
```
With
```
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
```

## Bun

### Bun Install

```sh
brew tap oven-sh/bun # for macOS and Linux
brew install bun
```


## AI Stack Install (Work in progress)

Heavily inspired by (technotim)[https://technotim.live/posts/ai-stack-tutorial/#general-docker-compose-stack]

#### Docker support

Docker does not currently suppoart Apple Silicon GPU Passthrough at the time of this commit, therefore we must run our AI stack natively in python or whatever native language it's in.


### 1. Ollama

This was already installed above as as cask, but since brew doesn't allow editing the launchctl files, we need to use our own. Save `ollama.plist` in `~/.ollama/ollama.plist`.

```bash
brew services stop ollama
brew services start ollama --file=/Users/jason/.ollama/ollama.plist 
```

### 2. Open Web UI & SearXNG

Run the docker compose for these
```bash
docker compose up -d
```

## Mac Disk Cleanup

When low on disk space, see [mac-disk-cleanup.md](./mac-disk-cleanup.md). Covers iOS / watchOS simulator runtimes, Xcode DerivedData, Docker, and Homebrew — the full sweep freed ~67 GB last time.
