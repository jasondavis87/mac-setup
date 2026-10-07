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
Target OS: macOS 27 (last verified against Tahoe 26.6)

## 3 Screen setup
Docking Station: [StarTech USB-C 4K Triple Monitor Docking Station](https://www.amazon.com/gp/product/B07LGR8Y14)
Monitors: 
- 3x [Sceptre 32 inch QHD IPS Monitor HDR400 2560x1440 DisplayPort up to 144Hz](https://www.amazon.com/dp/B08VTW474P?psc=1&ref=ppx_yo2ov_dt_b_product_details)

# Table of Contents

- Before you wipe
- Bootable installer
- Xcode Command Line Tools
- Homebrew / Terminal / Shell
- Install everything via Brewfile
  - Cursor extensions
- Claude MCP Servers (Apple Search Ads, App Store Connect, others)
- Git Config
- Finder Settings
- Menu Bar Customization
- Node.js
  - Globals: yarn / pnpm / turbo / task-master-ai
- ohMyZSH (.zshrc / .zprofile / .zshenv)
- Bun
- Rust / Python (uv)
- AI Stack
- Mac Disk Cleanup

## Before you wipe

Run through this on the old install before erasing anything:

- Export code-signing identities (Apple Development / Distribution certs + private keys) from Keychain Access as `.p12` files, with a password.
- Export Raycast settings (Raycast Settings > Advanced > Export).
- Back up dotfiles (`~/.zshrc`, `~/.zprofile`, `~/.zshenv`, `~/.ssh/`, `~/.gitconfig`, `~/.config/`) and every project's `.env*` files. None of these belong in this repo.
- Back up API key files (`.p8`, service-account `.json`) used by the MCP servers and CLIs below.
- Check every git repo for unpushed work: uncommitted changes, stashes, and local-only branches.
- Make sure crypto wallet seed phrases are written down and verified.
- Collect license keys for paid apps (iStat Menus, audio plugins, Office, Ableton, etc.).

## Bootable installer

Optional, but handy for a true clean install (erase the internal disk first, then install from USB):

```sh
softwareupdate --list-full-installers
softwareupdate --fetch-full-installer --full-installer-version <version>
sudo "/Applications/Install macOS <Name>.app/Contents/Resources/createinstallmedia" --volume /Volumes/<USB_NAME>
```

`createinstallmedia` erases the target USB drive (16 GB or larger). See Apple's guide: [Create a bootable installer for macOS](https://support.apple.com/en-us/101578).

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

Currently using cmux (built on Ghostty's lib, but i like it better). Tried Ghostty, Warp and iTerm in the past. iTerm i've retired completely. Warp I liked the AI features, but i rarely used them.

Installed via the `Brewfile` step below, no extra command needed.

### Shell

Reference: [Link](https://ohmyz.sh/#install)

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Using the default `robbyrussell` theme now (no Powerlevel10k). See [ohMyZSH](#ohmyzsh) below for what goes in `.zshrc` / `.zprofile` / `.zshenv`.

## Install everything via Brewfile

One command installs every tap, formula, cask, and Mac App Store app listed in `Brewfile`:

```sh
brew bundle --file=Brewfile
```

Third-party taps carry `trusted: true` because current Homebrew refuses to load untrusted taps.

To see what changed after manual installs/uninstalls, dump to a temp file and diff (dumping straight over `Brewfile` drops the hand-written comments, like the Ollama note):

```sh
brew bundle dump --force --file=/tmp/Brewfile.now
diff Brewfile /tmp/Brewfile.now
brew bundle cleanup --file=Brewfile   # dry run: lists installed items not in Brewfile
```

#### App Selection notes:
- Spotlight Repalcement: I used to use alfred, now I use raycast exclusively.
- Alt-tab: I used to use alt-tab, but trying without this year. The default ones seems good enough. We'll see.
- Discord: I've switched to Legcord. No particular reason other than it was suggested.
- Stats: i tried `stats` for a year and it was OK. I went back to iStatMenus having a license already.
- Scroll-reverser: I personally scroll my mouse backwards ane use my trackpad normally. So this helps with that. 
- Cursor is my IDE of choice although i also have VSCode as a backup (no extensions installed in it).
- AI tools: Claude desktop, Claude Code (`claude-code@latest`), Codex, Cursor CLI, T3 Code (nightly), plus CodexBar and Claude Usage Tracker in the menu bar.
- Networking: Tailscale (app cask, ships its own CLI), cloudflared, ngrok, mitmproxy, PingPlotter, WiFiman.

### Cursor extensions

Not in the `Brewfile`: `brew bundle`'s `vscode` entries go to whichever editor CLI it finds first (`code` before `cursor`), so they would land in VS Code. Install them into Cursor directly once Cursor's shell command is on PATH (Cursor > Command Palette > "Install 'cursor' command"):

```sh
for ext in \
  aaron-bond.better-comments \
  anthropic.claude-code \
  anysphere.remote-containers \
  anysphere.remote-ssh \
  bradlc.vscode-tailwindcss \
  chakrounanas.turbo-console-log \
  christian-kohler.path-intellisense \
  dbaeumer.vscode-eslint \
  denoland.vscode-deno \
  esbenp.prettier-vscode \
  expo.vscode-expo-tools \
  formulahendry.auto-close-tag \
  formulahendry.auto-rename-tag \
  github.github-vscode-theme \
  hamster.task-master-hamster \
  ibm.output-colorizer \
  johnpapa.vscode-peacock \
  pkief.material-icon-theme \
  redhat.vscode-yaml
do cursor --install-extension "$ext"; done
```

Regenerate the list with `cursor --list-extensions`.

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
      <string>/opt/homebrew/bin/brew update --quiet &amp;&amp; /opt/homebrew/bin/brew upgrade --greedy --quiet &amp;&amp; /opt/homebrew/bin/brew cleanup --prune=7 --quiet</string>
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
plutil -lint ~/Library/LaunchAgents/com.user.brew-auto-update.plist   # must print OK
```

The `&&` has to be written as `&amp;&amp;` inside the plist XML, otherwise the file is invalid and launchd refuses to load it.

Caveat: `--greedy` also upgrades self-updating casks. Casks that install a `.pkg` or otherwise need `sudo` (DisplayLink, the Canon driver, BlackHole, etc.) can't prompt for a password from launchd, so their upgrades fail unattended. Check `/tmp/brew-auto-update.err` now and then and run `brew upgrade --greedy` by hand for those.

### 2. Load it

```sh
launchctl load ~/Library/LaunchAgents/com.user.brew-auto-update.plist
launchctl start com.user.brew-auto-update
```

### (Unload it if needed)
```sh
launchctl unload ~/Library/LaunchAgents/com.user.brew-auto-update.plist
```

## Google Play review monitor

Daily check (9am) for new Google Play reviews across all five apps, via a launchd agent. Because Google's Reviews API only returns text reviews from ~the last 7 days, `gplay-review-monitor.sh` permanently archives every review it sees to `~/.gplay/reviews-archive.jsonl` (so nothing is lost once captured) and only flags new/unreplied ones.

Files (repo root): `gplay-reviews.plist` (label `local.gplay-reviews`, no env vars), `gplay-review-monitor.sh` (sets its own PATH so launchd finds `gplay`/`jq`). Data — archive, seen-list, log — lives in `~/.gplay/` and is not tracked.

### Install
```sh
cp gplay-reviews.plist ~/Library/LaunchAgents/local.gplay-reviews.plist
launchctl bootstrap gui/$UID ~/Library/LaunchAgents/local.gplay-reviews.plist
launchctl kickstart -k gui/$UID/local.gplay-reviews   # optional: run once now
```
Reads `~/.gplay/review-monitor.log` for output. Run manually anytime with `./gplay-review-monitor.sh`.

### Update / uninstall
```sh
launchctl kickstart -k gui/$UID/local.gplay-reviews            # re-run after editing the script
launchctl bootout gui/$UID/local.gplay-reviews                 # uninstall
```
Requires `gplay` (Homebrew) authenticated via service account at `~/.gplay/keys/`.

## Claude MCP Servers

Two Apple MCP servers are registered **user-scoped** in Claude Code (`-s user`), so Claude can use them across every project for this user. Both are **stdio** servers: Claude spawns them on demand and nothing runs in the background between sessions. Other MCP servers in use are listed in [Other MCP servers](#3-other-mcp-servers).

**Key locations:** the Apple Search Ads key lives next to its server checkout at `~/.apple-search-ads/asa-private.p8`; the App Store Connect key lives at `~/.config/asc-mcp/asc-private.p8`. These are **never committed** to this repo (see [Keys after a wipe](#verify--keys-after-a-wipe)).

> Full install/build steps live in each project's own README (linked below). This section only captures the `claude mcp add` wiring needed to reconnect them on a fresh machine. Replace every `<PLACEHOLDER>` with your real value — do **not** commit real keys/IDs to this public repo.

### 1. Apple Search Ads — [AppVisionOS/apple-search-ads-mcp](https://github.com/AppVisionOS/apple-search-ads-mcp)

Node MCP for managing Apple Search Ads campaigns, keywords, and reports.

Setup (see project README): clone into `~/.apple-search-ads/`, install deps and build (produces `dist/index.js`); place the ASA private key at `~/.apple-search-ads/asa-private.p8`. Then register it user-scoped:

```sh
claude mcp add apple-search-ads -s user \
  -e ASA_CLIENT_ID=<ASA_CLIENT_ID> \
  -e ASA_TEAM_ID=<ASA_TEAM_ID> \
  -e ASA_KEY_ID=<ASA_KEY_ID> \
  -e ASA_ORG_ID=<ASA_ORG_ID> \
  -e ASA_PRIVATE_KEY_PATH=$HOME/.apple-search-ads/asa-private.p8 \
  -- node $HOME/.apple-search-ads/apple-search-ads-mcp/dist/index.js
```

(IDs come from the Apple Search Ads API setup under Account Settings → API.)

### 2. App Store Connect reviews — [zelentsov-dev/asc-mcp](https://github.com/zelentsov-dev/asc-mcp)

Swift MCP for App Store Connect, used here to **monitor and reply to customer reviews** across all apps. Unlike Google Play, the ASC reviews API returns full history (no 7-day window), so no archiving workaround is needed.

Install via **Mint** (consistent, fixed location under `~/.mint/`):

```sh
brew install mint                          # also in Brewfile
mint install zelentsov-dev/asc-mcp@v3.0.2  # builds binary → ~/.mint/bin/asc-mcp
```

Place the ASC API key at `~/.config/asc-mcp/asc-private.p8`, then register it user-scoped. It is registered with no extra args, so every worker is enabled:

```sh
claude mcp add asc-mcp -s user \
  -e ASC_KEY_ID=<ASC_KEY_ID> \
  -e ASC_ISSUER_ID=<ASC_ISSUER_ID> \
  -e ASC_PRIVATE_KEY_PATH=$HOME/.config/asc-mcp/asc-private.p8 \
  -e ASC_VENDOR_NUMBER=<ASC_VENDOR_NUMBER> \
  -- $HOME/.mint/bin/asc-mcp
```

To narrow it, append `--workers <list>` after the binary, e.g. `--workers reviews,analytics,metrics,apps`: `reviews` = read/reply to customer reviews · `analytics` = App Store analytics (impressions→conversion→downloads funnel by source/territory) + sales/finance reports · `metrics` = per-version performance & diagnostics · `apps` = enumerate apps + their Apple IDs. Append `--read-only` to block all writes (note: that disables review replies too).

> **Gotcha:** `reviews_list`/`reviews_stats` return a `500` from Apple on unfiltered queries — always pass a `territory`, as **ISO alpha-3** (`USA`, `GBR`), not alpha-2. The `ASC_VENDOR_NUMBER` (App Store Connect → Payments and Financial Reports) is required for sales/finance analytics; the App Analytics funnel path works without it. Create the key in App Store Connect → **Users and Access → Integrations → App Store Connect API** with the **Admin** role — it's the only single role that makes every tool across all three workers function (App Manager covers reviews + App Analytics + metrics but *not* Apple sales/finance reports, and a key's role can't be edited later — only revoked + recreated). The `.p8` grants account-level access; only a `--workers` list would limit which domains the agent can touch.

### 3. Other MCP servers

Also registered user-scoped. No keys or account values here; add them from your own accounts.

- `task-manager-ai`: stdio, `task-master-mcp` from the `task-master-ai` npm global (see Node.js).
- `play-store`: stdio, `uvx --with "mcp<2" play-store-mcp`, with `GOOGLE_APPLICATION_CREDENTIALS` pointing at a Google Play service-account JSON in `~/.config/play-store-mcp/`.
- `maestro`: stdio, `maestro mcp` (Maestro CLI from the Brewfile) for mobile UI test flows.
- `context7`: HTTP, `https://mcp.context7.com/mcp` (library docs).
- `mobbin`: HTTP, `https://api.mobbin.com/mcp` (UI reference screens).
- `higgsfield`: HTTP, `https://mcp.higgsfield.ai/mcp` (image/video generation).
- `astro`: HTTP MCP served by the Astro ASO desktop app on a local port.

```sh
claude mcp add --transport http context7 -s user https://mcp.context7.com/mcp
claude mcp add maestro -s user -- maestro mcp
```

HTTP servers that need auth prompt for it on first use (`/mcp` in an interactive session).

### Verify & keys after a wipe

```sh
claude mcp list                       # confirm each shows ✔ Connected
claude mcp get asc-mcp                # inspect command/env for one
claude mcp remove <name> -s user      # remove one
```

> **Keys are not in this repo.** After reinstalling, restore each `.p8` from your secure backup (or regenerate it in the relevant Apple portal) to the paths above, then verify it's still valid — Apple keys can be revoked or expire. If `claude mcp list` shows a server failing, a missing/stale key or wrong path is almost always why.

## Git Config

```sh
git config --global user.email "YOUR_EMAIL"
git config --global user.name "YOUR NAME"
git config --global core.editor "nano"
git config --global url."git@github.com:".insteadOf "https://github.com/"   # always use SSH for GitHub
git lfs install                                                           # adds the filter.lfs.* entries
```

Global ignore file: git reads `~/.config/git/ignore` by default (no `core.excludesFile` needed). It currently holds:

```sh
mkdir -p ~/.config/git
echo '**/.claude/settings.local.json' >> ~/.config/git/ignore
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

- Hidden Bar: collapse rarely used icons behind the arrow.
- iStat Menus: CPU / GPU / memory / network stats (register the license).
- CodexBar and Claude Usage Tracker: AI usage limits at a glance.

## Node.js w/ yarn/pnpm

Node comes from Homebrew (`brew "node"` in the `Brewfile`), no version manager. The machine gets rebuilt every year anyway, and one Node major per year is plenty, so this setup tracks Node 26 for the year.

Global CLIs:

```sh
npm install -g yarn turbo task-master-ai @expo/ngrok
```

`pnpm` comes from the `Brewfile`. `expo-cli` is deprecated; use `npx expo` per project (and `eas-cli` from Bun below).

Homebrew's `node` formula follows the newest Node release, so the daily brew auto-upgrade will jump to the next major when it ships. To hold the current major, run `brew pin node`. A pin also blocks that major's patch releases, so run `brew unpin node && brew upgrade node && brew pin node` now and then. Or switch to the versioned formula once it exists, e.g. `node@26`, which is keg-only and needs its `bin` on `PATH`.


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

Xcode betas come from [developer.apple.com/download](https://developer.apple.com/download/) and sit next to the release build (e.g. `Xcode-<version>.app`).

(These are also in `Brewfile`, so `brew bundle` handles them too once you're signed into the App Store.)

### Other Programs
- Waves Central
- Omnisphere
- Komplete 11
- Microsoft Office (cask `microsoft-office`, commented out in `Brewfile`)
- Ableton Live 12 Suite (cask `ableton-live-suite`, commented out in `Brewfile`; register it)
- iStatMenu
- Register iStat Menu (save on dropbox)


## ohMyZSH

Theme is the stock `robbyrussell`; plugins are `git node vscode`. Keep the oh-my-zsh installer's template and add the blocks below. Three files, each with one job:

- `~/.zprofile`: login-shell setup (OrbStack).
- `~/.zshrc`: interactive shell (oh-my-zsh, toolchain PATHs, aliases).
- `~/.zshenv`: sourced by every zsh, including non-interactive ones. Homebrew rustup and Cargo PATHs belong here. Keep personal tokens and env vars out of this repo.

Homebrew's installer adds `/opt/homebrew/bin` via `/etc/paths.d/homebrew`. If `brew` isn't found in a new shell, add `eval "$(/opt/homebrew/bin/brew shellenv)"` to the top of `~/.zprofile`.

### .zshrc

Additions after the oh-my-zsh template:

```sh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git node vscode)
source $ZSH/oh-my-zsh.sh

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Java (openjdk@17 from Brewfile, for Android/React Native builds)
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

# Android SDK (installed by Android Studio)
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"

# task-master shortcuts
alias tm='task-master'
alias taskmaster='task-master'

# uv (adds ~/.local/bin to PATH; created by the uv installer)
. "$HOME/.local/bin/env"

# ffmpeg-full is keg-only; put its bin first
export PATH="/opt/homebrew/opt/ffmpeg-full/bin:$PATH"
```

### .zprofile
```sh
source ~/.orbstack/shell/init.zsh 2>/dev/null || :   # added by OrbStack
```

### .zshenv
```sh
# Homebrew rustup is keg-only; ~/.cargo/bin holds cargo-installed CLIs.
if [[ -d /opt/homebrew/opt/rustup/bin ]]; then
  export PATH="/opt/homebrew/opt/rustup/bin:$HOME/.cargo/bin:$PATH"
else
  export PATH="/usr/local/opt/rustup/bin:$HOME/.cargo/bin:$PATH"
fi
# export any personal tokens and env vars here (kept out of this repo)
```

## Bun

### Bun Install

`bun` comes from the `oven-sh/bun` tap in the `Brewfile`. Global CLIs:

```sh
bun add -g eas-cli wrangler clerk zapier-platform-cli
bun add -g --trust @higgsfield/cli   # needs its postinstall script
```

## Rust / Python (uv)

Rust: `rustup` comes from the `Brewfile` (the `rust` formula is intentionally not installed, it conflicts with rustup-managed toolchains).

```sh
rustup default stable
cargo install tauri-cli
```

Homebrew's `rustup` is keg-only. Use the `.zshenv` PATH block above for Apple Silicon or Intel instead of relying on `~/.cargo/env`, then open a new shell before running the commands. `~/.cargo/bin` makes cargo-installed CLIs such as `cargo-tauri` available.

Python: [uv](https://docs.astral.sh/uv/) via its standalone installer (creates `~/.local/bin/env`, sourced in `.zshrc`). `uvx` runs Python MCP servers such as `play-store-mcp`.

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## AI Stack Install (Work in progress)

Heavily inspired by (technotim)[https://technotim.live/posts/ai-stack-tutorial/#general-docker-compose-stack]

#### Docker support

Docker does not support Apple Silicon GPU passthrough (re-checked June 2026 — Docker Desktop/OrbStack still can't expose the Metal GPU to a Linux container), therefore we must run Ollama natively and keep only the web UI stack in Docker.


### 1. Ollama

**Try brew first.** As of June 2026 the formula is broken on Apple Silicon — the bottle is missing the `llama-server` runner, so the server starts and answers `/api/version` but every model fails to load with `llama-server binary not found` ([homebrew-core#285917](https://github.com/Homebrew/homebrew-core/issues/285917)). Check whether it's fixed:

```bash
brew install ollama
brew services start ollama
ollama run llama3.1:8b "say hi"   # must actually generate text, not 500
```

If that generates text, brew is fixed: restore `brew "ollama", restart_service: :changed, link: false` in the Brewfile and skip the fallback below.

**Fallback: official release tarball** (current install). The GitHub release ships the complete runtime including `llama-server`:

```bash
brew uninstall ollama 2>/dev/null   # don't mix the two installs
mkdir -p ~/.ollama/runtime
curl -L -o /tmp/ollama-darwin.tgz https://github.com/ollama/ollama/releases/latest/download/ollama-darwin.tgz
tar -xzf /tmp/ollama-darwin.tgz -C ~/.ollama/runtime
ln -sf ~/.ollama/runtime/ollama /opt/homebrew/bin/ollama
cp ollama.plist ~/Library/LaunchAgents/local.ollama.plist
launchctl bootstrap gui/$UID ~/Library/LaunchAgents/local.ollama.plist
```

`ollama.plist` (repo root) sets `OLLAMA_FLASH_ATTENTION=1`, `OLLAMA_KV_CACHE_TYPE=q8_0`, `OLLAMA_KEEP_ALIVE=1h` (how long an idle model stays resident in memory before unloading), and logs to `~/.ollama/ollama.log`.

To update the tarball install: re-download, re-extract, then `launchctl kickstart -k gui/$UID/local.ollama`.

To switch back to brew once fixed:

```bash
launchctl bootout gui/$UID/local.ollama
rm ~/Library/LaunchAgents/local.ollama.plist /opt/homebrew/bin/ollama
rm -rf ~/.ollama/runtime    # models in ~/.ollama/models are untouched
```

### 2. Open Web UI & SearXNG

Run the docker compose for these
```bash
docker compose up -d
```

### 3. Image generation (local, in the Open WebUI chat)

Open WebUI drives image generation through Ollama's OpenAI-compatible
`/v1/images/generations` endpoint — no ComfyUI / Automatic1111 needed. The
wiring lives in `compose.yaml` (the `IMAGE_*` / `IMAGES_OPENAI_*` env vars);
you just need the model on the host:

```bash
ollama pull x/z-image-turbo      # 12 GB, Alibaba Z-Image-Turbo (fast, photoreal)
# optional, higher quality / slower:
# ollama pull x/flux2-klein
```

Then in Open WebUI, open a chat, send a prompt, and click the image icon on the
response (or use the Image tab). First image loads the model (~adds a few sec).

**Speed note:** Ollama's MLX image runner is experimental and ~10x slower per
denoising step than a tuned pipeline, so resolution dominates: ~25s at 512px
(the compose default) vs ~2 min at 1024px. Bump it in **Admin > Settings >
Images** when you want final quality. Draw Things / ComfyUI are faster but don't
drop into the Open WebUI chat as cleanly (Draw Things has no native Open WebUI
support; ComfyUI needs a separate Python stack) — revisit if Ollama's speed
becomes a blocker.

Why Z-Image over "Nano Banana": Nano Banana is Google's Gemini image model,
cloud-only — it can't run locally. Z-Image-Turbo and FLUX.2 Klein are the local
open-weight equivalents.

## Mac Disk Cleanup

When low on disk space, see [mac-disk-cleanup.md](./mac-disk-cleanup.md). Covers iOS / watchOS simulator runtimes, Xcode DerivedData, Docker, and Homebrew.
