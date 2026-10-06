# Current Homebrew requires third-party taps (or individual items from them) to be
# trusted before it will load them. `trusted: true` records that on install,
# so `brew bundle` runs unattended on a fresh machine.
tap "hamed-elfayome/claude-usage", trusted: true
tap "minio/stable", trusted: true
tap "mobile-dev-inc/tap"
tap "oven-sh/bun", trusted: true
tap "tamtom/tap", trusted: true
tap "twilio/brew", trusted: true

# === Formulae ===
brew "asitop"
brew "boost"
brew "ca-certificates"
brew "cloudflared"
brew "cmake"
brew "cocoapods"
brew "cowsay"
brew "curl"
brew "deno"
brew "fastlane"
# ffmpeg-full is keg-only (more codecs than plain `ffmpeg`). Linked here, and
# its bin dir is also prepended to PATH in ~/.zshrc (see README "Shell").
brew "ffmpeg-full", link: true
brew "fortune"
brew "gh"
brew "git"
brew "git-filter-repo"
brew "git-lfs"
brew "gradle"
brew "imagemagick"
brew "imessage-exporter"
brew "ios-deploy"
brew "iperf3"
brew "jenv"
brew "libimobiledevice"
brew "libpq", link: true
brew "mas"
brew "mingw-w64"
brew "mint"
# ollama: formula DISABLED June 2026 — the Apple Silicon bottle for 0.30.x is
# missing the llama-server runner, so the server starts but every model fails
# to load (https://github.com/Homebrew/homebrew-core/issues/285917).
# Installed from the official release tarball instead — see "AI Stack Install
# > 1. Ollama" in README.md. Once the formula is fixed, restore this line:
# brew "ollama", restart_service: :changed, link: false
brew "node" # Node 26; the README explains holding a major with `brew pin node`
brew "openjdk@17"
brew "oxipng"
brew "pandoc"
brew "pnpm"
brew "poppler"
brew "qrencode"
brew "rclone"
# Current rsync 3.x; macOS ships openrsync (rsync 2.6.9 compatible).
brew "rsync"
# Rust toolchains come from rustup (`rustup default stable`), not the `rust` formula.
brew "rustup"
brew "sentry-cli"
brew "sound-touch"
brew "stripe-cli"
brew "supabase"
# Not needed: Tailscale.app (cask below) installs its own CLI to /usr/local/bin.
# brew "tailscale"
brew "tcptraceroute"
brew "vcprompt"
brew "wakeonlan"
brew "watchman"
brew "wget"
brew "yt-dlp"
brew "minio/stable/mc"
brew "mobile-dev-inc/tap/maestro", trusted: true
brew "oven-sh/bun/bun"
brew "tamtom/tap/gplay"
brew "twilio/brew/twilio"

# === Casks ===
cask "android-file-transfer"
cask "android-platform-tools"
cask "android-studio"
cask "anydesk"
cask "basictex"
cask "blackhole-2ch"
cask "bruno"
cask "canon-ufrii-driver"
cask "capcut"
cask "claude"
cask "claude-code@latest"
cask "cmux"
cask "codex"
cask "codexbar"
cask "cursor"
cask "cursor-cli"
cask "displaylink"
cask "dropbox"
cask "excalidrawz"
cask "figma"
cask "fluidvoice"
cask "font-hack-nerd-font"
cask "google-chrome"
cask "hamed-elfayome/claude-usage/claude-usage-tracker"
cask "hiddenbar"
cask "istat-menus"
cask "keka"
cask "legcord"
cask "macwhisper"
cask "mitmproxy"
cask "modrinth"
cask "ngrok"
cask "obs"
cask "onyx"
cask "orbstack"
cask "raycast"
cask "rectangle"
cask "screen-studio"
cask "scroll-reverser"
# Nightly build only; switch to (or add) the stable "t3-code" cask if preferred.
cask "t3-code@nightly"
cask "tailscale-app"
cask "visual-studio-code"
cask "vlc"
cask "whatsapp"
cask "wifiman"
# FFXIV launcher (bundles its own Wine; replaces the old final-fantasy-xiv-online cask)
cask "xiv-on-mac"
cask "zen"
cask "zoom"

# Installed manually on the current machine. Casks exist; uncomment to let
# brew manage them (licensed apps still need to be registered after install).
# cask "ableton-live-suite"
# cask "microsoft-office"

# === Mac App Store ===
mas "Logic Pro", id: 634148309
mas "TestFlight", id: 899247664
mas "Xcode", id: 497799835

# Cursor extensions are NOT listed here: `brew bundle`'s `vscode` entries install
# into the first editor CLI it finds (`code` before `cursor`), so with VS Code
# installed they would land in VS Code. See README "Cursor extensions".
