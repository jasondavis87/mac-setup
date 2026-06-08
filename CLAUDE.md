# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal macOS bootstrap repo, not a software project. Jason re-runs it on each new major macOS release to reinstall and reconfigure everything. There is no build, no lint, no tests — just package manifests, a docker compose file, an ollama launchd plist, and `README.md` as the human-facing playbook.

Treat `README.md` as the source of truth for the install order and step-by-step instructions; this file only captures things that aren't obvious from reading it.

## Package manifest

`Brewfile` is the single source of truth for installs. On a fresh macOS install, `brew bundle --file=Brewfile` provisions every formula, cask, Mac App Store app, and VS Code extension at once. The older `brew-formulae.txt` / `brew-casks.txt` lists were deleted (they had drifted from the Brewfile and were a constant source of "which list do I add this to?" confusion).

When adding a package, edit `Brewfile` directly. To regenerate from current install state: `brew bundle dump --force --describe --file=Brewfile` — note this rewrites the whole file alphabetically and replaces any hand-written comments with auto-generated descriptions, so prefer surgical edits over dump when preserving structure matters.

Per-formula option worth preserving on regeneration: `brew "ollama", restart_service: :changed, link: false` — pairs with the custom `ollama.plist` workflow below.

## AI stack topology (compose.yaml)

The compose stack is `open-webui` + `searxng` + `watchtower`, but **Ollama itself runs natively on the host via brew services**, not in a container — Docker on macOS can't pass through Apple Silicon GPU. The container reaches host Ollama via `OLLAMA_BASE_URL=http://host.docker.internal:11434` plus an `extra_hosts: host.docker.internal:host-gateway` entry.

Open WebUI ↔ SearXNG uses the container DNS name (`searxng:8080`), not localhost.

Neither service publishes ports by default; access is via OrbStack's domain proxying. Uncomment the `ports:` blocks if the user explicitly wants host ports.

`watchtower` auto-updates only `open-webui` and `searxng` (named in its `command:`), every 300s.

The `config/open-webui/` bind mount holds runtime state (sqlite DB, vector DB, uploads, cache) and is **gitignored** — do not commit anything under it. `config/searxng/settings.yml` *is* committed; treat `settings.yml.new` as a scratch/staging file from a prior upgrade.

## Ollama launchd customization

`ollama.plist` is a replacement for the homebrew-managed launchd plist, intended to be copied to `~/.ollama/ollama.plist` and loaded via `brew services start ollama --file=…`. The custom version sets `OLLAMA_KEEP_ALIVE=24h`, `ENABLE_IMAGE_GENERATION=True`, and `COMFYUI_BASE_URL=http://localhost:7860`. If editing this, remember the corresponding `brew services stop ollama` / restart-with-file dance in the README — `brew services` won't pick up edits to the plist on its own.

## Node toolchain

The README installs **two** Node versions via nvm (24 as default, plus 22) and installs `yarn`, `pnpm`, and `expo-cli` globally into each. If asked to "add a global npm tool", add it under both versions unless told otherwise.

## Things not to do

- Don't add lint/build/test scaffolding — this isn't that kind of repo.
- Don't generate a CI pipeline.
- Don't rewrite the README into a different structure; it's the author's personal playbook and the section order matches his reinstall workflow.
