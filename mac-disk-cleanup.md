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

## 5. Docker

```bash
docker system df                       # see what's using space first
docker system prune -a --volumes       # remove all unused images, containers, networks, volumes
```

The `-a` flag removes images not currently used by any container (not just dangling). `--volumes` is destructive to anonymous volumes — fine for me since I don't keep persistent local dev data in Docker volumes.

---

## 6. Homebrew

```bash
brew cleanup -s     # remove old versions and scrub the download cache
brew autoremove     # remove orphaned dependencies
```

---

## Skip — diminishing returns

- **Metal Toolchain.** React Native apps don't pull from Xcode's Metal toolchain, and the disk savings are tiny. If I ever do want to clean it: Xcode → Settings → Components → trash icon next to old entries. Never `rm -rf` — `mobileassetd` owns that asset DB and CLI removal corrupts it.

---

## After

```bash
df -h /
```
