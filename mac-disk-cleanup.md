# Mac Disk Cleanup Routine

Run when low on disk space.

## Before you start

```bash
df -h /
```

---

## 1. iOS Simulator Runtimes

I'm an iOS dev — **always keep the latest iOS runtime**. Delete every older version.

List what's installed:
```bash
xcrun simctl list runtimes
```

Then for each older iOS runtime UUID, run:
```bash
xcrun simctl runtime delete <UUID>
```

Note: the iOS runtime bundled inside Xcode itself can't be deleted with `simctl` (and you wouldn't want to — it ships with the IDE). Only the separately-downloaded disk images are deletable.

---

## 2. watchOS Simulator Runtimes

Safe to delete **all** of them — I don't build for watchOS.

Same pattern: `xcrun simctl runtime delete <UUID>` for every watchOS entry from the list above.

---

## 3. CoreSimulator Caches

```bash
rm -rf ~/Library/Developer/CoreSimulator/Caches/*
```

---

## 4. Xcode DerivedData

Always safe — regenerates on next build.

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/* && echo "DerivedData cleared"
```

---

## 5. iOS DeviceSupport

Per-iOS-version debug symbol caches, created when you connect a real device on that OS version. They regenerate the next time you plug that device in. **Keep the versions matching devices I still use**; delete the old ones (and any duplicates of the same x.y build).

List by size:
```bash
du -sh ~/Library/Developer/Xcode/iOS\ DeviceSupport/* | sort -rh
```

Delete a specific old build (quote the path — it has spaces and parens):
```bash
rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/"<iPhone/iPad model> <version> (<build>)"
```

Glob-delete a whole major version I no longer have a device on:
```bash
rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/*17.7*
```

---

## 6. watchOS DeviceSupport

Same idea, but safe to delete **all** — I don't build for watchOS.

```bash
rm -rf ~/Library/Developer/Xcode/watchOS\ DeviceSupport/* && echo "watchOS DeviceSupport cleared"
```

---

## 7. Xcode Archives

Built app archives + dSYMs. **Not** auto-regenerated — there's no rebuilding them from here once gone. Check first, don't blanket-delete: review what's there and only remove archives already submitted/distributed.

```bash
du -sh ~/Library/Developer/Xcode/Archives/* | sort -rh     # review what's here first
rm -rf ~/Library/Developer/Xcode/Archives/<archive>        # delete individually once confirmed
```

---

## 8. Docker

```bash
docker system df                       # see what's using space first
docker system prune -a --volumes       # remove all unused images, containers, networks, volumes
```

The `-a` flag removes images not currently used by any container (not just dangling). `--volumes` is destructive to anonymous volumes — fine for me since I don't keep persistent local dev data in Docker volumes.

---

## 9. Homebrew

Plain `brew cleanup` only scrubs cached downloads it considers stale, so it barely touches the big `~/Library/Caches/Homebrew/downloads` dir (hundreds of old installer DMGs/bottles). Use `--prune=all` to clear **all** cached downloads regardless of age — this is the single biggest Homebrew win. It's a proper brew command (no `rm` needed) and zero risk: nothing installed is touched, brew just re-downloads on demand if it ever needs a file again.

```bash
brew cleanup --prune=all -s     # remove old versions AND wipe the entire download cache
brew autoremove                 # remove orphaned dependencies
```

(For a lighter pass that keeps "current" downloads, drop `--prune=all`.)

---

## 10. Gradle caches

Android build cache — regenerates on next build (the following build is slower while it refills).

```bash
rm -rf ~/.gradle/caches/* && echo "Gradle caches cleared"
```

---

## 11. CocoaPods cache

Downloaded pod sources — regenerates on the next `pod install` (which is slower while it re-fetches). There's a proper CLI for this, so no `rm` needed:

```bash
du -sh ~/Library/Caches/CocoaPods     # check size first
pod cache clean --all                 # clears every cached pod
```

---

## 12. Other regenerable caches

All safe to wipe — each app/tool refills on next use.

```bash
rm -rf ~/Library/Caches/Ableton/*            # Ableton
rm -rf ~/Library/Caches/org.swift.swiftpm/*  # Swift Package Manager
rm -rf ~/Library/Caches/ms-playwright/*       # Playwright browsers (re-download on demand)
```

To find the next round of cache hogs:
```bash
du -sh ~/Library/Caches/* | sort -rh | head -15
```

---

## Skip — leave these alone

- **Metal Toolchain.** React Native apps don't pull from Xcode's Metal toolchain, and the disk savings are tiny. If I ever do want to clean it: Xcode → Settings → Components → trash icon next to old entries. Never `rm -rf` — `mobileassetd` owns that asset DB and CLI removal corrupts it.
- **node_modules in old projects.** I clear these manually with `npx npkill`, and I'm often actively working in some of them. Don't bulk-delete.
- **Personal data and app data** — large dirs under `~/Library/Application Support`, `~/Music`, `~/.ollama` (local models), etc. Often the biggest items on disk, but not cleanup targets. Ask before touching.

---

## After

```bash
df -h /
```
