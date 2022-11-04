# My Mac Setup

When a new major version of MacOS comes out, i reinstall everything and follow this repo

Inspired by: [CodingGarden/mac-setup](https://github.com/CodingGarden/mac-setup) - [YouTube Vid](https://www.youtube.com/watch?v=2_ZbslLnshw)

- Xcode Command Line Tools
- Homebrew / Terminal / Shell
- Brew Formulae
- brew Casks
- Finder Settings
- Menu Bar Customization
- Node.js
  - Globals: yarn / expo-cli

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

iTerm will be installed when doing brew casks

### Shell

Reference: [Link](https://ohmyz.sh/#install)

```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
#### USE POWER LEVEL 10k ####

## Brew Formulae

Reference the text file: ```brew-formulae.txt```

This will install:

```
git, vcprompt, cowsay, fortune, bash, ffmpeg, openjdk, iperf3
```

## Brew Casks

Reference the text file: ```brew-casks.txt```

This will install: 

```
alfred, dropbox, docker, google-chrome, rectangle, alt-tab, android-file-transfer, android-platform-tools, keepingyouawake, discord, slack, istat-menus, vlc, keka, kap, figma, scroll-reverser, time-out, visual-studio-code, zoom
```

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

## Node.js w/ yarn 

Install Node Version Manager and Yarn for each version

Repo Link: [GitHub](https://github.com/nvm-sh/nvm)

```curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash```

```
nvm install 16
nvm use 16
npm install -g yarn
npm install -g expo-cli
npm install -g @aws-amplify/cli

nvm install 18
nvm use 18
npm install -g yarn
npm install -g expo-cli
npm install -g @aws-amplify/cli
```


## Additional Applications

- Ableton Live 11
- Logic Pro X (from App Store)
- MainStage 3 (from App Store)
- DisplayLink Manager (for 3 screen hub)
- Waves Central
- CleanMyMac X
- Microsoft Office


## Misc
- Register iStat Menu


## TODO
- Write ohMyZSH Script

```

```