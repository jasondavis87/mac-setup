# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal macOS bootstrap repo, not a software project. Jason re-runs it on each new major macOS release to reinstall and reconfigure everything. There is no build, no lint, no tests — just package manifests, a docker compose file, an ollama launchd plist, and `README.md` as the human-facing playbook.

Treat `README.md` as the source of truth for the install order and step-by-step instructions; this file only captures things that aren't obvious from reading it.

## Package manifest

`Brewfile` is the single source of truth for installs. On a fresh macOS install, `brew bundle --file=Brewfile` provisions every formula, cask, Mac App Store app, and VS Code extension at once. The older `brew-formulae.txt` / `brew-casks.txt` lists were deleted (they had drifted from the Brewfile and were a constant source of "which list do I add this to?" confusion).

When adding a package, edit `Brewfile` directly. To regenerate from current install state: `brew bundle dump --force --describe --file=Brewfile` — note this rewrites the whole file alphabetically and replaces any hand-written comments with auto-generated descriptions, so prefer surgical edits over dump when preserving structure matters.

The ollama formula is deliberately **commented out** (June 2026): the Apple Silicon bottle is missing the `llama-server` runner, so models can't load. Ollama is installed from the official release tarball instead (see below). A `brew bundle dump` would silently drop that comment block — preserve it, and don't re-add `brew "ollama"` until [homebrew-core#285917](https://github.com/Homebrew/homebrew-core/issues/285917) is fixed.

## AI stack topology (compose.yaml)

The compose stack is `open-webui` + `searxng` + `watchtower`, but **Ollama itself runs natively on the host via a launchd agent**, not in a container — Docker on macOS can't pass through Apple Silicon GPU (still true as of June 2026). The container reaches host Ollama via `OLLAMA_BASE_URL=http://host.docker.internal:11434` plus an `extra_hosts: host.docker.internal:host-gateway` entry.

Open WebUI ↔ SearXNG uses the container DNS name (`searxng:8080`), not localhost.

**Image generation** is wired through the same host Ollama: the `IMAGE_*` / `IMAGES_OPENAI_*` env vars in `compose.yaml` point Open WebUI's `openai` image engine at Ollama's OpenAI-compatible `/v1/images/generations` (`http://host.docker.internal:11434/v1`, dummy API key `ollama`), with `x/z-image-turbo` as the model. No ComfyUI/Automatic1111. These are Open WebUI **PersistentConfig** vars — they seed a fresh DB on first boot but are ignored once a value exists in the DB, so don't expect env-var edits to take on an already-configured install without `ENABLE_PERSISTENT_CONFIG=False` or an Admin-UI change. Ollama's MLX image runner is experimental and slow (~20s/step), so the compose default is 512px; resolution is the main speed lever.

Neither service publishes ports by default; access is via OrbStack's domain proxying. Uncomment the `ports:` blocks if the user explicitly wants host ports.

`watchtower` auto-updates only `open-webui` and `searxng` (named in its `command:`), every 300s.

The `config/open-webui/` bind mount holds runtime state (sqlite DB, vector DB, uploads, cache) and is **gitignored** — do not commit anything under it. `config/searxng/settings.yml` *is* committed; treat `settings.yml.new` as a scratch/staging file from a prior upgrade.

## Ollama install (launchd, not brew services)

Ollama's runtime lives in `~/.ollama/runtime/` (extracted from the official `ollama-darwin.tgz` GitHub release — it bundles `llama-server`, which the brew bottle lacks), with the CLI symlinked to `/opt/homebrew/bin/ollama`. The repo's `ollama.plist` (label `local.ollama`) is copied to `~/Library/LaunchAgents/local.ollama.plist` and managed with plain `launchctl bootstrap`/`bootout`/`kickstart`, **not** `brew services`. It sets `OLLAMA_FLASH_ATTENTION=1`, `OLLAMA_KV_CACHE_TYPE=q8_0` (carried over from the brew formula's service defaults), and `OLLAMA_KEEP_ALIVE=1h` (idle-unload timeout); logs go to `~/.ollama/ollama.log`. If editing the plist, re-copy it to LaunchAgents and `launchctl bootout` + `bootstrap` again — launchd won't pick up edits on its own. Full install/update/switch-back-to-brew steps are in the README's "AI Stack Install > 1. Ollama" section.

A gotcha worth remembering: a *running* Ollama server survives `brew upgrade`, so the server and its on-disk runner binaries can drift apart until every model load fails — if models suddenly stop loading after an upgrade, restart the service first.

## Node toolchain

The README installs **two** Node versions via nvm (24 as default, plus 22) and installs `yarn`, `pnpm`, and `expo-cli` globally into each. If asked to "add a global npm tool", add it under both versions unless told otherwise.

## Things not to do

- Don't add lint/build/test scaffolding — this isn't that kind of repo.
- Don't generate a CI pipeline.
- Don't rewrite the README into a different structure; it's the author's personal playbook and the section order matches his reinstall workflow.
