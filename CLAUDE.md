# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal macOS bootstrap repo, not a software project. Jason re-runs it on each new major macOS release to reinstall and reconfigure everything. There is no build, no lint, no tests — just package manifests, a docker compose file, an ollama launchd plist, and `README.md` as the human-facing playbook.

Treat `README.md` as the source of truth for the install order and step-by-step instructions; this file only captures things that aren't obvious from reading it.

## Package manifests — Brewfile vs. .txt lists

There are **two parallel ways** packages are tracked, and they have diverged:

- `Brewfile` — full `brew bundle` manifest with taps, `brew`, `cask`, `mas`, and `vscode` extension entries, plus per-formula options (e.g. `brew "ollama", restart_service: :changed, link: false`). This is the comprehensive list.
- `brew-formulae.txt` / `brew-casks.txt` — plain newline-separated lists used by the `xargs brew install < …` commands in the README. These are **smaller subsets** of the Brewfile and intentionally so (e.g. `brew-casks.txt` lists `zen` and `bruno`, which are not in the Brewfile; the Brewfile lists many casks not in `.txt`).

When adding a package, ask which list the user wants it in — they are not auto-synced. Don't "reconcile" them without being asked.

`Brewfile` is listed in `.gitignore` but is committed (the gitignore line predates the commit). Leave it tracked.

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
